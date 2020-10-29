
# res-react-script-loader

A script loader for reason-react written in rescript-lang.

## Installation

Using NPM:

```sh
npm install --save @bettercart/res-react-script-loader
```

Using Yarn:

```sh
yarn add @bettercart/res-react-script-loader
```

Then add `@bettercart/res-react-script-loader` to `bs-dependencies` in your `bsconfig.json`:
```js
{
  ...
  "bs-dependencies": ["@bettercart/res-react-script-loader"]
}
```

Optional Dependencies (Used for callback) - https://github.com/reasonml-community/bs-webapi-incubator

Using NPM:

```sh
npm install --save bs-webapi
```

Using Yarn:

```sh
yarn add bs-webapi
```

Then add `bs-webapi` to `bs-dependencies` in your `bsconfig.json`:
```js
{
  ...
  "bs-dependencies": ["bs-webapi"]
}
```


## Usage 

ReactScript has a simgle export that is a custom react hook `useScript`.

The `useScript` hook will return the status of the tag that you can listen for to handle different states in your
rendering, but you can also pass in named callbacks `onLoad` and `onFailure`.


```
  open ReactScript

  let onLoad = (event: Webapi.Dom.Event.t) => {
    Js.log2("Loaded", event)
  }

  let onFailure = (event: Webapi.Dom.Event.t) => {
    Js.log2("Failed", event)
  }

  /* only a single script tag is created per unique url */

  let scriptStatus: Script.status = Script.useScript(~src=url, ~onLoad, ~onFailure)

  switch scriptStatus {
  | Idle => <div> {"Idle"->React.string} </div>
  | Loading => <div> {"Loading"->React.string} </div>
  | Ready => <div> {"Ready"->React.string} </div>
  | Failed => <div> {"Failed"->React.string} </div>
  }

```
