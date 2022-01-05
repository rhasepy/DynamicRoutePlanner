class Edge
{
  int source;
  int dest;
  double weight;
  double pheremone;

  Edge(int source, int dest, double weight, double pheremone)
  {
    this.source = source;
    this.dest = dest;
    this.weight = weight;
    this.pheremone = pheremone;
  }
  @override
  String toString() {
    return "Source: " + source.toString() + " " +
          "Dest: " + dest.toString() + " " +
          "W: " + weight.toString() + " " +
          "P: " + pheremone.toString() + "\n";
  }
}