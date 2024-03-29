type status =
  | Idle
  | Loading
  | Ready
  | Failed

let useScript = (~src: string, ~onLoad=?, ~onFailure=?, ~crossorigin=?, ~async=?, ()) => {
  let (status: status, setStatus) = React.useState(_ => Idle)

  let handleOnLoad = (script, event) => {
    Webapi.Dom.Element.setAttribute("data-status", "ready", script)
    setStatus(_ => Ready)
    switch onLoad {
    | Some(cb) => cb(event)
    | _ => ()
    }
  }

  let handleOnError = (script, event) => {
    Webapi.Dom.Element.setAttribute("data-status", "failed", script)
    setStatus(_ => Failed)
    switch onFailure {
    | Some(cb) => cb(event)
    | _ => ()
    }
  }

  React.useEffect1(() => {
    setStatus(_ => Loading)

    let existingScript = Webapi.Dom.Document.querySelector(
      j`script[src="${src}"]`,
      Browser.document,
    )

    switch existingScript {
    | Some(s) => {
        setStatus(_ =>
          switch Webapi.Dom.Element.getAttribute("data-status", s) {
          | Some(attr) =>
            switch attr {
            | "idle" => Idle
            | "loading" => Loading
            | "ready" => Ready
            | "failed" => Failed
            | _ => Idle
            }
          | _ => Idle
          }
        )

        Webapi.Dom.Element.addEventListener("load", event => handleOnLoad(s, event), s)
        Webapi.Dom.Element.addEventListener("error", event => handleOnError(s, event), s)

        Some(
          () => {
            Webapi.Dom.Element.removeEventListener("load", error => handleOnLoad(s, error), s)
            Webapi.Dom.Element.removeEventListener("error", error => handleOnError(s, error), s)
          },
        )
      }
    | None => {
        let script = Webapi.Dom.Document.createElement("script", Browser.document)
        let _document = Browser.document

        Webapi.Dom.Element.setAttribute("src", src, script)

        Webapi.Dom.Element.setAttribute("data-status", "loading", script)

        switch crossorigin {
        | Some(co) => Webapi.Dom.Element.setAttribute("crossorigin", co, script)
        | None => ignore()
        }

        switch async {
        | Some(_) => Webapi.Dom.Element.setAttribute("async", "true", script)
        | None => Webapi.Dom.Element.setAttribute("async", "false", script)
        }

        Webapi.Dom.Element.addEventListener("load", event => handleOnLoad(script, event), script)
        Webapi.Dom.Element.addEventListener("error", event => handleOnError(script, event), script)

        let headElements = Webapi.Dom.Document.getElementsByTagName("head", Browser.document)
        switch Webapi.Dom.HtmlCollection.item(0, headElements) {
        | Some(head) => Webapi.Dom.Element.appendChild(script, head)
        | _ => setStatus(_ => Failed)
        }

        Some(
          () => {
            Webapi.Dom.Element.removeEventListener(
              "load",
              error => handleOnLoad(script, error),
              script,
            )
            Webapi.Dom.Element.removeEventListener(
              "error",
              error => handleOnError(script, error),
              script,
            )
          },
        )
      }
    }
  }, [src])

  status
}
