// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import Cart__FormController from "./cart/form_controller"
application.register("cart--form", Cart__FormController)

import Cart__IconController from "./cart/icon_controller"
application.register("cart--icon", Cart__IconController)

import Cart__ItemController from "./cart/item_controller"
application.register("cart--item", Cart__ItemController)

import Category__AssignController from "./category/assign_controller"
application.register("category--assign", Category__AssignController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import Product__CartProductController from "./product/cart_product_controller"
application.register("product--cart-product", Product__CartProductController)

import Product__LikeController from "./product/like_controller"
application.register("product--like", Product__LikeController)

import Product__SaleInfoController from "./product/sale_info_controller"
application.register("product--sale-info", Product__SaleInfoController)
