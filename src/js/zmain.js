/*	Read Only by HTML5 UP html5up.net | @n33co	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license) */

(function ($) {
  skel.breakpoints({
    xlarge: "(max-width: 1680px)",
    large: "(max-width: 1280px)",
    medium: "(max-width: 1024px)",
    small: "(max-width: 736px)",
    xsmall: "(max-width: 480px)",
  });

  $(function () {
    var $body = $("body"),
      $header = $("#header"),
      $nav = $("#nav"),
      $nav_a = $nav.find("a"),
      $wrapper = $("#wrapper");

    // Fix: Placeholder polyfill.
    $("form").placeholder();

    // Prioritize "important" elements on medium.
    skel.on("+medium -medium", function () {
      $.prioritize(
        ".important\\28 medium\\29",
        skel.breakpoint("medium").active
      );
    });

    // Keep these strictly to the navbar.
    var ids = [];
    var $navLinks = $nav.find("a");

    // Navbar links: scrolly + click handler + id assignment for scrollzer.
    $navLinks
      .scrolly({ offset: 44 })
      .on("click", function (event) {
        var $this = $(this),
          href = $this.attr("href");

        if (href.charAt(0) != "#") return;

        event.preventDefault();

        $navLinks.removeClass("active").addClass("scrollzer-locked");
        $navLinks.filter('a[href="' + href + '"]').addClass("active");
      })
      .each(function () {
        var $this = $(this),
          href = $this.attr("href"),
          id;

        if (!href || href.charAt(0) != "#") return;

        id = href.substring(1);

        // Only navbar gets these ids.
        $this.attr("id", id + "-link");
        ids.push(id);
      });

    // Optional: in-article links that should smooth-scroll, but must NOT get ids.
    $('a[class$="-link"]').not($navLinks).scrolly({ offset: 44 });

    // Initialize scrollzer
    $.scrollzer(ids, { pad: 300, lastHack: true, navContainer: "#nav" });

    // Off-Canvas Navigation.

    // Title Bar.
    $(
      '<div id="titleBar">' +
        '<a href="#header" class="toggle"></a>' +
        '<span class="title">' +
        $("#logo").html() +
        "</span>" +
        "</div>"
    ).appendTo($body);

    // Header.
    $("#header").panel({
      delay: 500,
      hideOnClick: true,
      hideOnSwipe: true,
      resetScroll: true,
      resetForms: true,
      side: "right",
      target: $body,
      visibleClass: "header-visible",
    });

    // Fix: Remove navPanel transitions on WP<10 (poor/buggy performance).
    if (skel.vars.os == "wp" && skel.vars.osVersion < 10)
      $("#titleBar, #header, #wrapper").css("transition", "none");
  });
})(jQuery);
