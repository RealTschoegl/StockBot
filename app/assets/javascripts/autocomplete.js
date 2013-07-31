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

    acNode.ac.on("select", function (e) {
        $('button').show();
        var users_stock_name = e.result.raw.name;
        document.getElementById("hiddenField").value = users_stock_name;
        // alert(e.result.raw.symbol);
        // $.ajax({
        //   type: "POST",
        //   url: "/stocks/picker",
        //   data: {stock_tbd: stock_symbol}
        // });
    });

    
    

});