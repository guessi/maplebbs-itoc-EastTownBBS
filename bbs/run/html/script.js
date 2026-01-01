var curr = 0;
var keyEvent = 0;
var baseurl = "http://bbs.ndhu.edu.tw:8080";

$.ajaxSetup({
  cache : false
});

const checkURL = (p) => {
  /* 0: not valid, 1: valid */
  return (typeof p != "undefined" && p.length > 0);
}

const highlight = (pos) => {
  if (pos >= 0 && pos <= 19) {
    $("#curPos").val(pos);
    $(".listitem:not(:nth-child(" + (pos + 1) + "))").removeClass('highlight');
    $(".listitem:nth-child(" + (pos + 1) + ")").addClass("highlight");
  }
}

const loadPage = (next, pos) => {
  if (pos >= 0 && pos <= 19) {
    $("#content").load(next + " #content", () => {
      var loc = (next.charAt(0) == '?') ? (window.location.pathname + next) :
                (next.charAt(0) == '/') ? (baseurl + next) : "";
      if (checkURL(loc)) {
        window.history.pushState("", document.title, loc);
      }
      highlight(pos);
    });
  }
}

const keyEventHandler = (key) => {
  var link = "";
  /* 1 ~ 20 */
  var ilen = $(".listitem").length;
  /* 0 ~ 19 */
  curr = parseInt($("#curPos").val());
  
  if (key == 66 || key == 98) {
    /* brdlist, [B:66], [b:98] */
    loadPage("/brdlist", 1);
  } else if (key == 67 || key == 99) {
    /* class, [C:67], [c:99] */
    window.location.href = "/class";
  } else if (key == 72 || key == 104) {
    /* hotboard, [M:72], [m:104] */
    loadPage("/hotboard", 1);
  } else if (key == 77 || key == 109) {
    /* home, [M:77], [m:109] */
    window.location.href = "/home";
  } else if (key == 33) {
    /* [PgUp:33] */
    if (ilen > 0) {
      link = $(".cmdPgUp a").attr("href");
      if (checkURL(link)) {
        /* keep current position */
        $("#curPos").val(curr);
        loadPage(link, curr);
      } else {
        curr = 0;
        highlight(curr);
      }
    }
  } else if (key == 34) {
    /* [PgDn:34] */
    if (ilen > 0) {
      link = $(".cmdPgDn a").attr("href");
      if (checkURL(link)) {
        /* keep current position */
        $("#curPos").val(curr);
        loadPage(link, curr);
      } else {
        curr = ilen - 1;
        highlight(curr);
      }
    }
  } else if (key == 35) {
    /* [End:35] */
    if (ilen > 0) {
      link = $(".cmdEnd a").attr("href");
      if (!checkURL(link)) {
        return;
      }
      curr = ilen - 1;
      $("#curPos").val(curr);
      loadPage(link, curr);
    }
  } else if (key == 36) {
    /* [Home:36] */
    if (ilen > 0) {
      link = $(".cmdHome a").attr("href");
      if (!checkURL(link)) {
        return;
      }
      curr = 0;
      $("#curPos").val(curr);
      loadPage(link, curr);
    }
  } else if (key == 37) {
    /* [LEFT:37] */
    link = ($(".upper").length > 0) ? $(".upper a").attr("href") : $(".cmdLeft a").attr("href");
    if (!checkURL(link)) {
      return;
    }
    window.location.href = link;
  } else if (key == 13 || key == 39) {
    /* [RETURN:13] */
    /* [RIGHT:39] */
    if (ilen > 0) {
      link = $(".listitem:nth-child(" + (curr + 1) + ") a.cmdRight").attr("href");
      curr = 0;
      $("#curPos").val(curr);
      if (!checkURL(link)) {
        return;
      }
      loadPage(link, curr);
    }
  } else if (key == 38) {
    /* [UP:38] */
    curr--;
    if (curr < 0) {
      link = $(".cmdPgUp a").attr("href");
      if (!checkURL(link)) {
        return;
      }
      curr = 19;
      $("#curPos").val(curr);
      loadPage(link, curr);
    }
    highlight(curr);
  } else if (key == 40) {
    /* [DOWN:40] */
    curr++;
    if (curr > (ilen - 1)) {
      link = $(".cmdPgDn a").attr("href");
      if (!checkURL(link)) {
        return;
      }
      curr = 0;
      $("#curPos").val(curr);
      loadPage(link, curr);
    }
    highlight(curr);
  }
}

$(() => {
  /* highlight previous selected item */
  highlight(curr);
  /* order: keydown -> keypress -> keyup */
  /* A(65)~Z(90), a(97)~z(122) */
  $(document).keypress((e) => {
    /* ctrl/alt/shift whould never happend at keyPress */
    var key = e.which ? e.which : (e.keyCode ? e.keyCode : 0);
    if (!keyEvent) {
      keyEventHandler(key);
    }
  });
  
  $(document).keydown((e) => {
    var ctrlKey = e.ctrlKey;
    var shiftKey = e.shiftKey;
    var altKey = e.altKey;
    if (ctrlKey || shiftKey || altKey) {
      return
    };
    keyEvent = 1;
    var key = e.which ? e.which : (e.keyCode ? e.keyCode : 0);
    keyEventHandler(key);
  });
  
  $(document).keyup((e) => {
    /* restore */
    keyEvent = 0;
  });
  
  /* mouse move detection */
  $(".listitem").hover((e) => {
    $(".listitem").removeClass('highlight');
    $(e.currentTarget).addClass('highlight');
    curr = $(".listitem").index(e.currentTarget);
    $("#curPos").val(curr);
  });
  
  /* permanent link */
  $("#plink span input").click((e) => {
    $(e.currentTarget).focus().select();
  });
  
  $("#share").click((e) => {
    if ($("#share .hidden").css("display") == "none") {
      $("#share .hidden").css("display", "block");
    } else {
      $("#share .hidden").css("display", "none");
    }
  });
});

/* Disappearing "Scroll to top" link with jQuery and CSS http://briancray.com/2009/10/06/scroll-to-top-link-jquery-css/ */
$(() => {
  var timer;
  var show = false;
  var $box = $('#message a');
  var $window = $(window);
  var top = $(document.body).children().first().position().top;
  
  $window.scroll(() => {
    window.clearTimeout(timer);
    timer = window.setTimeout(() => {
        if ($window.scrollTop() <= top) {
          show = false;
          $box.fadeOut(500);
        } else if (show == false) {
          show = true;
          $box.stop(true, true).show().click(() => {
            $box.fadeOut(500);
          });
        }
      }, 100);
  });
});
