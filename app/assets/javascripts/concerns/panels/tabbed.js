source('concerns/panelTabbed', ['concerns/concerns', 'concerns/panelBase'], function() {
    concerns.inheritWidgetBase('panelTabbed', $.concerns.panelBase, {
        
        /** TODO add functions:
         * - toggleTab(i)
         * - currentTab() -> int
         * 
         * and override:
         * - setHeader(text)
         * - setBody(text)
         */
        
    });
});