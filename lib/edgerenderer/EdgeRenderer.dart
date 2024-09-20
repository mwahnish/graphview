part of graphview;

abstract class EdgeRenderer {
  void render(Canvas canvas, Graph graph, Paint paint);


  Edge? hitTestEdges({required Graph graph, required Offset position});

  bool hitTestEdge({required Offset p1, required Offset p2, required Offset position}){
    return _distToSegment(p1: p1, p2: p2, position: position) < 10;
  }

  double _sqr(double x) => x * x;
  double _dist2(Offset p1, Offset p2) => _sqr(p1.dx - p2.dx) + _sqr(p1.dy - p2.dy);
  double _distToSegmentSquared({required Offset p1, required Offset p2, required Offset position}){
    var line_dist = _dist2(p1, p2);
    if (line_dist == 0) return _dist2(position, p1);
    var t = ((position.dx - p1.dx) * (p2.dx - p1.dx) + (position.dy - p1.dy) * (p2.dy - p1.dy)) / line_dist;
    t = max(0, min(1, t));
    return _dist2(position, Offset(p1.dx + t * (p2.dx - p1.dx), p1.dy + t * (p2.dy - p1.dy)));
  }
  double _distToSegment({required Offset p1, required Offset p2, required Offset position}){
    return sqrt(_distToSegmentSquared(p1: p1, p2: p2, position: position));
  }
}

void _drawDottedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
  var dottedPaint = Paint()
    ..color = paint.color
    ..strokeWidth = paint.strokeWidth
    ..style = PaintingStyle.stroke;

  var distance = (end - start).distance;
  var dashLength = 10;
  var gapLength = 10;
  var totalLength = dashLength + gapLength;

  final path = Path()..moveTo(start.dx, start.dy);
  for (var i = 0; i < distance; i += totalLength) {
    path.lineTo(start.dx + (i + dashLength) * (end.dx - start.dx) / distance,
        start.dy + (i + dashLength) * (end.dy - start.dy) / distance);
    path.moveTo(start.dx + (i + totalLength) * (end.dx - start.dx) / distance,
        start.dy + (i + totalLength) * (end.dy - start.dy) / distance);
  }

  canvas.drawPath(path, dottedPaint);
}
