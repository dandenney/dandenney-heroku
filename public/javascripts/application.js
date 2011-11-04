function convertHaml(input, options, root) {
  
  function reveal(selector) {
    root.find('.result').addClass('reveal');
  }
  function addResult(response) {
    root.addClass('processed').append('<pre class="result sh_html">' + response + '</pre>');
    setTimeout(function(){reveal('#codeschool')}, 100);
    sh_highlightDocument();
  }
  
  $.ajax({
    url: '/process',
    type: 'POST',
    data: {haml: input, options: options},
    cache: false,
    beforeSend: function() {
      // loading
    },
    error: function(jqXHR, textStatus) {
      addResult(textStatus);
    },
    success: function(html) {
      addResult(html);
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
