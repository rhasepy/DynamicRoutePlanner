import 'package:dynamicrouteplanner/CoreAlgorithm/Edge.dart';

import 'Ant.dart';

class DynamicACO
{
  double pheremone_deposit_w;
  double globalBestDistance;
  double min_scaling_factor;
  double initial_pheremone;
  double elitist_w;
  double alpha;
  double beta;
  double rho;

  int _colonySize = 10;
  int num_nodes;
  int steps;

  List<int> globalBestTour;
  List<List<double>> graph;
  List<List<Edge>> edges;
  List<String> prevPath;
  List<String> labels;
  List<int> nodes;
  List<Ant> ants;

  bool incompability;

  DynamicACO(int colony_size,
      List<List<double>> graph,
      int steps,
      List<String> labels,
      List<String> prevPath)
  {
    if(graph == null) {
      incompability = true;
    }
    else {
      this.globalBestTour = new List.empty();
      this._colonySize = colony_size;
      this.elitist_w = 1.0;
      this.min_scaling_factor = 0.001;
      this.alpha = 1.0;
      this.beta = 3.0;
      this.rho = 0.1;
      this.pheremone_deposit_w = 1.0;
      this.initial_pheremone = 1.0;
      this.pheremone_deposit_w = 1.0;
      this.steps = steps;
      this.num_nodes = graph.length;
      this.graph = graph;

      if (labels != null) {
        this.labels = labels;
      } else {
        this.labels = new List.empty();
        for (int i = 1; i < this.num_nodes + 1; ++i) {
          labels.add(i.toString());
        }
      }

      this.edges = List.generate(num_nodes, (index) => List.generate(num_nodes, (index) => null));

      for (int i = 0; i < this.num_nodes; ++i) {
        for (int j = i + 1; j < this.num_nodes; ++j) {
          double weight_ = this.graph[i][j];
          this.edges[i][j] = new Edge(i, j, weight_, this.initial_pheremone);
          this.edges[j][i] = new Edge(i, j, weight_, this.initial_pheremone);
        }
      }

      if (prevPath != null) {
        // TODO: Prev toura göre işlem yapılacak
      }

      this.ants = List.generate(this._colonySize, (index) => null);
      for (int i = 0; i < this._colonySize; ++i) {
        this.ants[i] = new Ant(this.alpha, this.beta, this.num_nodes, this.edges);
      }
      this.globalBestTour = List.empty();
      this.globalBestDistance = -1.0;
      incompability = false;
    }
  }

  void _acs()
  {
      for (int count = 0; count < this.steps; ++count) {
        for (Ant ant in ants) {
          this._add_pheremone(ant.find_tour(), ant.get_distance());
          if (ant.distance < this.globalBestDistance || this.globalBestDistance == -1) {
            this.globalBestTour = ant.tour;
            this.globalBestDistance = ant.distance;
          }
        }
        for (int i = 0; i < this.num_nodes; ++i) {
          for (int j = i + 1; j < this.num_nodes; ++j) {
            this.edges[i][j].pheremone *= (1.0 - this.rho);
          }
        }
      }
  }

  void _add_pheremone(List<int> tour, double distance) {
    double weight = 1.0;
    if (distance == 0.0) {
      distance = 0.1;
    }
    double pheromone_to_add = this.pheremone_deposit_w / distance;
    for (int i = 0; i < this.num_nodes; ++i) {
      this.edges[tour[i]][tour[(i + 1) % this.num_nodes]].pheremone +=
          weight * pheromone_to_add;
    }
  }

  void run()
  {
    this._acs();
    print("Route: ");
    print(this.globalBestTour);
    for (int i = 0; i < globalBestTour.length; ++i) {
      print(this.labels[globalBestTour[i]]);
    }
    print("\nCost: " + this.globalBestDistance.toString());
    this.incompability = true;
    // TODO: Prev Tour kayıt edilecek
  }
}