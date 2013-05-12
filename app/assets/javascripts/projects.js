$(function(){
    var BTN_TASK_ADD = $('#add_task');
    var FORM_TASK_NEW = $('.task-new');
    var INP_DATAPICKER = $('.datapick');

    $.fn.serializeObject = function()
    {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function() {
            if (o[this.name] !== undefined) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    };

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

    var FN_DATAPICKER_CLICK = function(e){
        e.stopPropagation();
        e.preventDefault();
        $(this).datepicker({
            inline: true,
            showOn: 'focus',
            dateFormat: 'dd.mm.yy'
        }).focus();
    };

    var FN_TASK_NEW = function(e){
        e.stopPropagation();
        e.preventDefault();
        var data = $(this).serializeObject();
        var values = _.values(data);
        if(typeof _.find(values, function(val){return val=="";}) == 'undefined'){

        }else{
            alert('Все поля обязательны для заполнения')
        }
    };

    $(document).on('click', INP_DATAPICKER.selector, FN_DATAPICKER_CLICK);
    $(document).on('submit', FORM_TASK_NEW.selector, FN_TASK_NEW);
    BTN_TASK_ADD.click(FN_TASK_ADD);
})