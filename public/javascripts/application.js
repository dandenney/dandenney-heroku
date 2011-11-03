function convertHaml(input, options, root) {
  $.ajax({
    url: '/process',
    type: 'POST',
    data: {haml: input, options: options},
    cache: false,
    beforeSend: function() {
      // loading
    },
    error: function(jqXHR, textStatus) {
      root.addClass('processed').append('<pre class="result">' + textStatus + '</pre>');
    },
    success: function(html) {
      root.addClass('processed').append('<pre class="result">' + html + '</pre>');
    }
  });
}

$(function(){
  $.deck('.slide');
  
  $(document).bind('deck.change', function(e, from, to) {
    var slide = $('.slide').eq(to);
    var next = $('.slide').eq(to+1);
    if (slide.hasClass('trigger')) {
      var root = slide.parent().parent();
      if (root.children('.result').length == 0) {
        var haml = root.children('.initial').text();
        var options = {
          ugly: root.attr('data-ugly') || false
        };
        convertHaml(haml, options, root);
      }
    } else if (next.hasClass('trigger')) {
      next.parents('.slide').removeClass('processed').children('.result').remove();
    }
  });
});
