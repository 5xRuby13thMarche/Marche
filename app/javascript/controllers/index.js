// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application";

import Cart__FormController from "./cart/form_controller";
application.register("cart--form", Cart__FormController);

import Cart__IconController from "./cart/icon_controller";
application.register("cart--icon", Cart__IconController);

import Cart__ItemController from "./cart/item_controller";
application.register("cart--item", Cart__ItemController);

import Category__AssignController from "./category/assign_controller";
application.register("category--assign", Category__AssignController);

import Category__OrderController from "./category/order_controller";
application.register("category--order", Category__OrderController);

import FlashController from "./flash_controller"
application.register("flash", FlashController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import Product__CartProductController from "./product/cart_product_controller";
application.register("product--cart-product", Product__CartProductController);

import Product__LikeController from "./product/like_controller";
application.register("product--like", Product__LikeController);

import Product__OrderController from "./product/order_controller";
application.register("product--order", Product__OrderController);

import Product__SaleInfoController from "./product/sale_info_controller";
application.register("product--sale-info", Product__SaleInfoController);

import Shop__OrderController from "./shop/order_controller";
application.register("shop--order", Shop__OrderController);

import User__AvatarController from "./user/avatar_controller";
application.register("user--avatar", User__AvatarController);

import Shop__ProductController from "./shop/product_controller"
application.register("shop--product", Shop__ProductController);

