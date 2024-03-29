// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  $('.popup').live('click',function(e) {
    url = this.href;
    $.fn.colorbox({href: url});
    return false;
  });

  $('.popupimage').colorbox({transition:"none",photo:'true', onLoad: function(){
    $('#cboxClose').css('top',"auto");
    $('#cboxClose').css('bottom','1px');
  }});
  
  $(".popup-big").colorbox({innerWidth:640, innerHeight:480, initialWidth:640, initialHeight:480, onLoad: function() {
    $('#cboxClose').remove();
  }});

  $("a.remove_link").live("click", function() {
    $(this).parents(".notification").hide();
    return false;
  });
  
  $(".part a.more_link").live("click", function() {
    form = $(this).closest(".event").find("form:last").first().clone();
    $.each($(form).find(":text, :checkbox"), function(i, el) { $(el).val("").attr("checked", false); });
    $(form).find("a.remove_link").removeClass("invisible");
    $(form).show();
    $(this).closest(".event").find("form:last").after(form);
    return false;
  });
  
  $(".milestone a.more_link").live("click", function() {
    li = $(this).closest("td").find("li.file:last").first().clone();
    return false;
  });

  $("a.toggle_advanced").live("click", function() {
    $(".advanced, .simple").toggle();
    return false;
  });

  $("#search form").live("submit", function() {
    var awb = $(this).find("input.hawb");
    $.each(awb, function(i, el) {
      val = $(awb).val().replace(/\D/, '');
      if (val.length != 8 && val.length != 11) {
        $(awb).closest("span.error").text("AWB number is invalid");
        return false;
      } else {
        check = val[val.length-1];
        val = val.substring(val.length-8, 7);
      }        
    });
  })

  $("input.datepicker").datepicker();
  
  $('.modal').modal('hide');
  
  $("input#all").click(function() {
    $(this).closest("table").find("input.all").attr("checked", $(this).attr("checked") == "checked")
  });
  
  $("input.all").click(function() {
    $(this).closest("table").find("input#all").attr("checked", $(this).closest("table").find("input.all:checked").length == $(this).closest("table").find("input.all").length)
  });
  
});


