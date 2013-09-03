// Public - This function is used to display the value of an html range slider.  
//
// 'textInput' - the id of the element in which the value of the slider is displayed
//
// Returns the value of the slider in a text field as a percentage

function updateTextInput(val) {
  document.getElementById('textInput').value=val + "%"; 
}