import 'dart:math';

import 'package:dynamicrouteplanner/CoreAlgorithm/Edge.dart';

class Ant
{
  double alpha;
  double beta;
  List<int> tour;
  double distance;
  int num_nodes;
  List<List<Edge>> edges;

  Ant(double alpha, double beta, int num_nodes, List<List<Edge>> edges)
  {
    this.alpha = alpha;
    this.beta = beta;
    this.num_nodes = num_nodes;
    this.edges = edges;
    this.tour = null;
    this.distance = 0.0;
  }

  List<int> _init_unvisited()
  {
    List<int> unvisited_nodes = [];
    for (int i = 0; i < num_nodes; ++i) {
      if (this.tour != null && (!this.tour.contains(i))){
        unvisited_nodes.add(i);
      }
    }
    return unvisited_nodes;
  }

  int _select_node()
  {
    double roulette = 0.0;
    double heuristic_total = 0.0;
    List<int> unvisited_nodes = this._init_unvisited();

    for (int unvisited in unvisited_nodes) {
      heuristic_total += this.edges[this.tour.last][unvisited].weight;
    }
    for (int unvisited in unvisited_nodes) {
      double w = this.edges[this.tour.last][unvisited].weight;
      if (w == 0.0) {
        w = 0.1;
      }
      double coeff = pow(this.edges[this.tour.last][unvisited].pheremone, this.alpha) * pow((heuristic_total / w), this.beta);
      roulette += coeff;
    }

    double random_value = 0 + (roulette - 0) * (new Random().nextDouble());
    double wheel_pos = 0.0;
    for (int unvisited in unvisited_nodes) {
      double w = this.edges[this.tour.last][unvisited].weight;
      if (w == 0.0) {
        w = 0.1;
      }
      double coeff = pow(this.edges[this.tour.last][unvisited].pheremone, this.alpha) * pow((heuristic_total / w), this.beta);
      wheel_pos += coeff;
      if (wheel_pos >= random_value) {
        return unvisited;
      }
    }
  }

  List<int> find_tour()
  {
    int rand_vertex = new Random().nextInt(999) % this.num_nodes;
    this.tour = [rand_vertex];
    while (this.tour.length < this.num_nodes)
      this.tour.add(this._select_node());
    return this.tour;
  }

  double get_distance()
  {
    this.distance = 0.0;
    for (int i = 0; i < num_nodes; ++i) {
      this.distance += this.edges[this.tour[i]][this.tour[(i + 1) % this.num_nodes]].weight;
    }
    return this.distance;
  }
}