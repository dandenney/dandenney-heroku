function convertHaml(input, options, root) {
  $.ajax({
    url: '/process',
    type: 'POST',
    data: {haml: input, options: options},
    cache: false,
    beforeSend: function() {
      // loading
    },
    error: function(jqXHR) {
      root.append('<pre class="result">' + jqXHR.responseText + '</pre>');
      root.attr('data-error','true');
    },
    success: function(html) {
      root.append('<pre class="result">' + html + '</pre>');
    }
  });
}

$(function(){
  $.deck('.slide');
  
  $(document).bind('deck.change', function(e, from, to) {
    var slide = $('.slide').eq(to);
    if (slide.hasClass('trigger')) {
      var root = slide.parent().parent();
      if (root.children('.result').length == 0) {
        var haml = root.children('.initial').text();
        var options = {
          ugly: root.attr('data-ugly') || false
        };
        convertHaml(haml, options, root);
      }
    }
  });
});
