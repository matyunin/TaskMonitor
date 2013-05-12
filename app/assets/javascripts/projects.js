$(function(){
    var BTN_TASK_ADD = $('#add_task');

    var FN_TASK_ADD = function(e){
        e.preventDefault();
        $this = $(this);
        $.fancybox({
            ajax : {
                type: 'GET',
                async: true,
                cache: false,
                url:   $this.attr('href')
                //data:  "pg="+url
            },
            helpers : {
                overlay : {
                    css : {
                        'background' : 'rgba(255, 255, 255, 0.1)'
                    }
                }
            }
        });
    }

    BTN_TASK_ADD.click(FN_TASK_ADD);
})