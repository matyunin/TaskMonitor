$(function(){
    var BTN_TASK_ADD = $('#add_task');

    var FN_TASK_ADD = function(e){
        e.preventDefault();
        $this = $(this);
        $.fancybox({
            type: 'ajax',
            href: $this.attr('href'),
            ajax : {
                type: 'GET',
                async: true,
                cache: false,
                data:  {}
            },
            helpers : {
                overlay : {
                    css : {
                        'background' : 'rgba(255, 255, 255, 0.1)'
                    }
                }
            }
        });
    };

    $(document).on('click', '.datapick', function(e){
        e.stopPropagation();
        e.preventDefault();
        $(this).datepicker({
            inline: true,
            showOn: 'focus',
            dateFormat: 'dd.mm.yy'
        }).focus();
    });

    BTN_TASK_ADD.click(FN_TASK_ADD);
})