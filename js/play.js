function bezier(cv,sx,sy,ax,ay,bx,by,fx,fy) {
    cv.beginPath();
    cv.moveTo(sx,sy);
    cv.bezierCurveTo(ax,ay,bx,by,fx,fy);
    cv.stroke();
}

function draw() {
    var canvas = document.getElementById("dish");
    var ctx = canvas.getContext("2d");

    ctx.lineWidth = 2;
    ctx.strokeStyle = "white";

    ctx.clearRect(0, 0, canvas.width, canvas.height);


    bezier(ctx,100,100,100,200,300,400,400,400);

    ctx.fillStyle = "#00ffff";
    ctx.beginPath();
    ctx.arc(75, 75, 10, 0, Math.PI*2, true); 
    ctx.closePath();
    ctx.fill();
 
}

    //    var can = document.getElementsByTagName('canvas')[0];
    // var ctx = can.getContext('2d');
    // ctx.fillStyle = "black";
    // ctx.beginPath();
    // ctx.rect(0,0,canvas.width, canvas.height);
    // ctx.closePath();
    // ctx.fill();
