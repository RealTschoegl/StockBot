/*global YUI, YAHOO:true, alert */

"use strict";

var YAHOO = {};
YAHOO.util = {};
YAHOO.util.ScriptNodeDataSource = {};

YUI({
    filter: "raw"
}).use("datasource", "autocomplete", "highlight", function (Y) {
    var oDS, acNode = Y.one("#ac-input");

    oDS = new Y.DataSource.Get({
        source: "http://d.yimg.com/aq/autoc?query=",
        generateRequestCallback: function (id) {
            YAHOO.util.ScriptNodeDataSource.callbacks =
                YUI.Env.DataSource.callbacks[id];
            return "&callback=YAHOO.util.ScriptNodeDataSource.callbacks";
        }
    });
    oDS.plug(Y.Plugin.DataSourceJSONSchema, {
        schema: {
            resultListLocator: "ResultSet.Result",
            resultFields: ["symbol", "name", "exch", "type", "exchDisp"]
        }
    });

    acNode.plug(Y.Plugin.AutoComplete, {
        maxResults: 10,
        resultTextLocator: "symbol",
        resultFormatter: function (query, results) {
            return Y.Array.map(results, function (result) {
                var asset = result.raw,
                    text =  asset.symbol +
                        " " + asset.name +
                        " (" + asset.type +
                        " - " + asset.exchDisp + ")";

                return Y.Highlight.all(text, query);
            });
        },
        requestTemplate:  "{query}&region=US&lang=en-US",
        source: oDS
    });  

    // Public: This function adds the user selected stock to a form on /index to be sent to /picker. 
    //  
    // 'button' - the css button that will display when the stock is selected
    // 'e.result.raw.name' - the string that is the selected stock's ticker symbol
    // 'hiddenField' - the id of an input field in the form
    //
    // Return - Shows the submit button once the user has selected a value.  It then takes the value that the user has selected and adds it to a hidden input field.

    acNode.ac.on("select", function (e) {
        $('button').show();
        var users_stock_name = e.result.raw.name;
        document.getElementById("hiddenField").value = users_stock_name;
    });

});