package com.intelligrape.linksharing.filters

class ApplicationFilters {

    def filters = {
        all(controller:'*', controllerExclude:'login', action:'*',actionExclude:'index') {
            before = {
                /*if (null == session && null == session.getAttribute("userId")) {
                    redirect(controller: "Home", action: "index")
                    return
                }*/
            }
            after = { Map model ->

            }
            afterView = { Exception e ->

            }
        }
    }
}
