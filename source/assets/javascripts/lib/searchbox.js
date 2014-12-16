$(document).ready(function(){
   $(".chosen-select").chosen({width: '95%'});
   $(".chosen-select").on('change', function(evt, params){
    // whatever TODO
      var t = $(".chosen-select option:selected").val();
      window.location = (t)
   })

});
