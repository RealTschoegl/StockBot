function updateTextInput(val) {
  document.getElementById('textInput').value=val + "%"; 
}

YUI().use("dial", function(Y) {

    var dial = new Y.Dial({
        min:-120,
        max:300,
        stepsPerRevolution:100,
        value: 0,
        strings:{label:'Drag to set:', resetStr: 'Reset'}
    });
    dial.render("#demo");

    var percent = Y.one('.yui3-dial-value-string');
    percent.append('%');

    function updateInput( e ){
        var val = e.newVal;
        if ( isNaN( val ) ) {
            // Not a valid number.
            return;
        }
        this.set( "value", val);
        percent.setHTML(val + '%');
    }

    var theInput = Y.one(document.getElementsByName("mod_stock_dial")[0]);
    dial.on("valueChange", updateInput, theInput);

});

YUI().use(
  'aui-rating',
  'node',
  function(Y) {
    var titleBox = Y.one('#titleBox');
    var instance, title, stars;

    var rating = new Y.StarRating(
      {
        boundingBox: '#myRating',
        disabled: false,
        label: "It's OK to be honest:   "
      }
    ).render();

    rating.on(
      'click',
      function(event) {
        instance = event.target;
        title = instance.get('title');
        stars = instance.get('value');

        if (!title) {
          titleBox.set('innerHTML', 'You selected <strong>0 stars</strong> - no rating!');
        }
        else {
          titleBox.set('innerHTML', 'You selected <strong>' + stars + ' stars</strong> - "' + title + '"!');
        }
      }
    );
  }
);