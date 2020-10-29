'use strict';


function make(f) {
  return {
          acceptNode: f
        };
}

exports.make = make;
/* No side effect */
