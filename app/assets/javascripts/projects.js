$(function(){
    var BTN_TASK_ADD = $('#add_task');

    var FN_TASK_ADD = function(e){
        e.preventDefault();
        $this = $(this);
        $.fancybox({
            href: $this.attr('href'),
            helpers : {
                overlay : {
                    css : {
                        'background' : 'rgba(255, 255, 255, 0.95)'
                    }
                }
            }
        });
    }

    BTN_TASK_ADD.click(FN_TASK_ADD);
})