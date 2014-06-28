$(document).ready(function(){
  if ($(window).width()<900){
    $(".nav-tabs").removeClass("nav-justified")
  }
  var a=$(".thumbnails");
  a.imagesLoaded(function(){
    a.masonry({
      columnWidth:".thumb",
      itemSelector:".thumb"
    })
  })
});
$(".favCmdFr").click(function(){
  var a=$(this).parent().attr("id");
  $.post("/fav/?q=fr",{id:a},function(){
      $("#"+a+">.favCmdFr").attr("disabled",true)
    })
});
$(".favCmdJp").click(function(){
  var a=$(this).parent().attr("id");
  $.post("/fav/?q=jp",{id:a},function(){
    $("#"+a+">.favCmdJp").attr("disabled",true)
  })
});
$(".booCmdFr").click(function(){
  var a=$(this).parent().attr("id");
  $.post("/boo/?q=fr",{id:a},function(){
    $("#"+a+">.booCmdFr").attr("disabled",true)
  })
});
$(".booCmdJp").click(function(){
  var a=$(this).parent().attr("id");
  $.post("/boo/?q=jp",{id:a},function(){
    $("#"+a+">.booCmdJp").attr("disabled",true)
  })
});