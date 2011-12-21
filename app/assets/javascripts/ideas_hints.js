function bindIdeaHandler() {
    var $idea_content = $('#idea_content').first();
    var $hint = $('.content .field .num').first();

    var idea_validator = {
        keyhandler : function(e) {
            var $this = $(this);
            $hint.find('span').html( "" + (400 - $this.attr('value').length) );
        }
    };

    if ($idea_content.length) {
        $idea_content.bind( 'keypress', idea_validator.keyhandler );
    }

}

