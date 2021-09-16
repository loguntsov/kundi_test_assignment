function findGetParameter(parameterName, default_value) {
    var result = null,
        tmp = [];
    var items = location.search.substr(1).split("&");
    for (var index = 0; index < items.length; index++) {
        tmp = items[index].split("=");
        if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
    }
    return result ? result : default_value;
}

var name = findGetParameter('name', 'alex') ;
var socket;
var callbacks = [];

function init_socket() {
    socket = new WebSocket("ws://localhost:8080/ws");
    socket.onopen = function() {
        send('set_name', { 'name': name })
    };

    socket.onclose = function(event) {
      if (event.wasClean) {

      } else {
        init_socket()
      }
    };

    socket.onmessage = function(event) {
        if (event.data=="pong") return;
        var data = JSON.parse(event.data)
        console.log(data);
        var type = data.event;
        var data = data.params;
        console.log(type, data)
        process_event(type, data)
    };

    socket.onerror = function(error) {
      alert("Error " + error.message);
      socket = null
    };
};

function process_event(type, data) {
    if (callbacks[type]) {
        (callbacks[type])(data)
    } else {
        console.log("Unknown event: ",type, data )
    }
}

callbacks["board"] = function(data) {
    var width = data.width;
    var height = data.height;
    var html = '';
    for(var i=1;i<=height;i++) {
        html += "<tr>"
        for(var j=1;j<=width;j++) {
            html += "<td id='"+cell_name(j, i)+"'></td>"
        }
        html += "</tr>";
    }
    document.getElementById("board").innerHTML = html

    for(const el of data.els) {
        board_set(el.x, el.y, el.what)
    }
}

callbacks["put"] = function(data) {
    board_set(data.x, data.y, data.player)
}

callbacks["move"] = function(data) {
    board_clean(data.old_pos.x, data.old_pos.y)
    board_set(data.new_pos.x, data.new_pos.y, data.player)
}

function cell_name(x, y) {
    return "cell_"+y+"_"+x;
}

function board_clean(x, y) {
    document.getElementById(cell_name(x, y)).innerHTML = ''
}

function board_set(x, y, what) {
    var html;

    if (what == 'wall') {
        html = "<img src='/static/img/wall.png'/>"
    } else
    if ( what.icon ) {
        css_class = (what.name == name) ? " class='selected' " : "";
        html = "<img src='"+what.icon+"'"+css_class+"/>";
    }
    document.getElementById(cell_name(x, y)).innerHTML = html;
}

function send(cmd, params) {
    socket.send(JSON.stringify({ 'cmd' : cmd, 'params': params }))
}

function move_left() {
    send("move_left", {})
}

function move_right() {
    send("move_right", {})
}

function move_top() {
    send("move_top", {})
}

function move_bottom() {
    send("move_bottom", {})
}

function attack() {
    send("attack", {})
}

init_socket();
setInterval(function() {
    if (socket) {
        socket.send("ping")
    }
}, 30000);

