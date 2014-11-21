module('concerns.panelTabbed', ['concerns', 'concerns.panelBase'], function(concerns) {
    return concerns.inheritWidgetBase('panelTabbed', $.concerns.panelBase, {
        
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