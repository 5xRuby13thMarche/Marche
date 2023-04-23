// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import Product__LikeController from "./product/like_controller"
application.register("product--like", Product__LikeController)

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))
