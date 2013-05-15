$(function(){
    var BTN_TASK_ADD = $('#add_task');
    var FORM_TASK_NEW = $('.task-new');
    var INP_DATAPICKER = $('.datapick');
    var day = 60;

    drawTasks(
        $('.tasks-container .c'),
        tasks
    );

    drawGrid(
        $('.tasks-container .c'),
        time_interval.start,
        time_interval.finish
    );

    function drawGrid(container, start, stop){
        var one = $('<div class="v-line"></div>');
        var mark = $('<div class="v-date"></div>');
        var count = parseInt( (stop - start) / (3600 * 24) );

        for(var i = 1; i <= count; i++){
            var date = new Date((start + 3600 * 24 * (i-1) ) * 1000);
            var s_date = date.getDate()+'.'+(date.getMonth()+1)+'.'+date.getFullYear();

            one.clone().appendTo(container).css({
                left: day * i
            }).append(mark.clone().text(s_date));
        }
    }

    function drawTasks(container, tasks){
        _.each(tasks, function(task, i){
            console.log(task);
            var task_block = $('<div class="task-item"></div>');
            var offset_timestamp = parseInt(task.start) - time_interval.start;
            var offset_px = parseInt(day * offset_timestamp / (3600 * 24));
            var length_timestamp = parseInt(task.finish) - parseInt(task.start);
            var length_px = parseInt(day * length_timestamp / (3600 * 24));
            var id = 'task' + task.id
            var plots = _.map(task.plots, function(plot){
                if(typeof plot != 'undefined')
                    return [parseInt(plot.time), plot.priority];
            });
            plots = _.sortBy(plots, function(plot){ return plot.time; });
            var values = _.map(plots, function(plot){
                return plot[1];
            });
            values.pop();

            task_block.clone()
                .appendTo(container)
                .css({
                    'margin-left': offset_px,
                    'width': length_px
                })
                .attr({
                    id: id
                });

            RRR(id, length_px, 89, length_timestamp / (3600 * 24), values);
        });
    }

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
                data:  { project_id: $('#project').val() }
            },
            helpers : {
                overlay : {
                    css : {
                        'background' : 'rgba(255, 255, 255, 0.5)'
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
            $.post(
                $(this).attr('action'),
                data,
                function(response){
                    //console.log(response);
                    window.location.reload();
                },
                'json'
            );
        }else{
            alert('Все поля обязательны для заполнения')
        }
    };

    $(document).on('click', INP_DATAPICKER.selector, FN_DATAPICKER_CLICK);
    $(document).on('submit', FORM_TASK_NEW.selector, FN_TASK_NEW);
    BTN_TASK_ADD.click(FN_TASK_ADD);

    function RRR(ID, W, H, len, values) {
        var r = Raphael(ID, W, H);
        //for (var i = len; i--;) {
        //    values.push(50);
        //}
        
        function translate(x, y) {
            return [
                30 + (W - 60) / (values.length - 1) * x,
                H - 10 - (H - 20) / 100 * y
            ];
        }
        
        function drawPath() {
            var p = [];
            for (var j = 1, jj = X.length; j < jj; j++) {
                p.push(X[j], Y[j]);
            }
            if(values.length>2){
                p = ["M", X[0], Y[0], "R"].concat(p);
                path.attr({path: p});
            }else if(values.length==2){
                p = ["M", X[0], Y[0], "L"].concat(p);
                path.attr({path: p});
            }
            //var subaddon = "L" + (W - 10) + "," + (H - 10) + ",50," + (H - 10) + "z";
            //sub.attr({path: p + subaddon});
        }
        
        var p = [["M"].concat(translate(0, values[0]))],
            color = "#08c",
            X = [],
            Y = [],
            blankets = r.set(),
            buttons = r.set(),
            w = (W - 60) / values.length,
            isDrag = -1,
            start = null,
            sub = r.path().attr({stroke: "none", fill: [90, color, color].join("-"), opacity: 0}),
            path = r.path().attr({stroke: color, "stroke-width": 2}),
            unhighlight = function () {};
        var ii;
        for (i = 0, ii = values.length - 1; i < ii; i++) {
            var xy = translate(i, values[i]),
                xy1 = translate(i + 1, values[i + 1]),
                f;
            X[i] = xy[0];
            Y[i] = xy[1];
            (f = function (i, xy) {
                buttons.push(r.circle(xy[0], xy[1], 5).attr({fill: color, stroke: "none"}));
                blankets.push(r.circle(xy[0], xy[1], w / 2)
                    .attr({stroke: "none", fill: "#fff", opacity: 0})
                    .mouseover(function () {
                        if (isDrag + 1) {
                            unhighlight = function () {};
                        } else {
                            buttons.items[i].animate({r: 10}, 200);
                        }
                    })
                    .mouseout(function () {
                        if (isDrag + 1) {
                            unhighlight = function () {
                                buttons.items[i].animate({r: 5}, 200);
                            };
                        } else {
                            buttons.items[i].animate({r: 5}, 200);
                        }
                    })
                    /*.drag(function (dx, dy) {
                        var start = this.start;
                        start && update(start.i, start.p + dy);
                    }, function (x, y) {
                        this.start = {i: i, m: y, p: Y[i]};
                    })*/
                );
                blankets.items[blankets.items.length - 1].node.style.cursor = "move";
            })(i, xy);
            if (i == ii - 1) {
                f(i + 1, xy1);
            }
        }
        xy = translate(ii, values[ii]);
        X.push(xy[0]);
        Y.push(xy[1]);
        
        drawPath();
        var update = function (i, d) {
            (d > H - 10) && (d = H - 10);
            (d < 10) && (d = 10);
            Y[i] = d;
            drawPath();
            buttons.items[i].attr({cy: d});
            blankets.items[i].attr({cy: d});
            r.safari();
        };
    }
})
