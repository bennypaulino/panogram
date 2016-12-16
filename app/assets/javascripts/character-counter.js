function pluralize(count, word){
  if (count == 1){
    return String(count) + ' ' + word;
  }else{
    return String(count) + ' ' + word + 's';
  }
}

$(document).ready(function($) {
  $( ".character-counter .field textarea" ).on( "keyup", function() {
    // $( this ).find( "p" ).focus();
    var $countdown = $( this ).parent().parent().find( ".countdown" )
    // 140 is the max message length
    var remaining = 140 - $( this ).val().length;

    $countdown.text(pluralize(remaining,'character') + ' remaining');

    var color = 'grey';
    if (remaining < 31) { color = 'black'; }
    if (remaining < 21) { color = '#ff7600'; } //orange
    if (remaining < 11) { color = '#de0000'; } //red
    $countdown.css( { color: color} );
  });
});

// $(document).ready(function($) {
//       updateCountdown();
//       $micropost_content = $('#micropost_content');

//       $micropost_content.change(updateCountdown);
//       $micropost_content.keyup(updateCountdown);
//       $micropost_content.keydown(updateCountdown);