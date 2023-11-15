// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import ToastController from "./toast_controller.js"
// import LoadRecaptchaV2Controller from "./load_recaptcha_v2_controller.js"

eagerLoadControllersFrom("controllers", application)

application.register("toast", ToastController)
// application.register("load_recaptcha_v2", LoadRecaptchaV2Controller)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
