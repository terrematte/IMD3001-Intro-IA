import numpy as np
import osmnx as ox
from collections import deque
import matplotlib.pyplot as plt

def haversine(lat1, lon1, lat2, lon2):
    
    """Distância aproximada em metros entre dois pares de (latitude, longitude)."""
    
    R = 6371000.0
    p1 = np.deg2rad(lat1)
    p2 = np.deg2rad(lat2)
    dphi = np.deg2rad(lat2 - lat1)
    dl   = np.deg2rad(lon2 - lon1)
    
    a = np.sin(dphi/2.0)**2 + np.cos(p1)*np.cos(p2)*np.sin(dl/2.0)**2
    
    return 2*R*np.arcsin(np.sqrt(a))


def graph(lat_o, lon_o, lat_d, lon_d, mode="walk", margin=500):

    """
    Baixa um grafo OSM que cobre a área entre origem e destino, com margem extra.
    mode: 'drive' | 'walk' | 'bike' | 'all'
    """
    
    dist = haversine(lat_o, lon_o, lat_d, lon_d) + margin
    
    lat_c = (lat_o + lat_d)/2
    lon_c = (lon_o + lon_d)/2
    
    return ox.graph_from_point(center_point=(lat_c, lon_c), dist=dist, network_type=mode, simplify=True)


def edges2streets(G, path_nodes):
    
    """
    Converte arestas do grafo para nomes de ruas aproximadas.
    """
    
    streets = []
    for u, v in zip(path_nodes[:-1], path_nodes[1:]):
        data_options = G.get_edge_data(u, v)
        
        if not data_options: # mão oposta, se necessário
            data_options = G.get_edge_data(v, u)  
        if not data_options:
            streets.append("(desconhecida)")
            continue
        
        data = list(data_options.values())[0]
        name = data.get('name')
        
        if isinstance(name, list) and name:
            streets.append(name[0])
        elif isinstance(name, str) and name.strip():
            streets.append(name)
        else:
            streets.append("(sem nome)")
    
    return streets


class Problem:
    
    def __init__(self, initial_state, actions, transition_model, goal_test, step_cost):
        
        self.initial_state = initial_state
        self.actions = actions                    # função actions(state) -> iterável de actions
        self.transition_model = transition_model  # função (state, action) -> new_state
        self.goal_test = goal_test                # função (state) -> bool
        self.step_cost = step_cost                # função (state, action) -> custo


class Node:

    def __init__(self, problem, parent=None, action=None):
        
        self.parent = parent
        self.action = action
        
        if parent is None:
            self.state = problem.initial_state
            self.path_cost = 0.0
        else:
            self.state = problem.transition_model(parent.state, action)
            self.path_cost = parent.path_cost + problem.step_cost(parent.state, action)
            
    
    def __eq__(self, other):
        return isinstance(other, Node) and self.state == other.state
    
    def __hash__(self):
        return hash(self.state)


class MapProblem(Problem):
    
    """
    Estados = IDs de nós do grafo OSMNX (NetworkX).
    Ações(state) = nós vizinhos alcançáveis por uma aresta (sucessores).
    Modelo de transição(state, action) = action (vizinho escolhido).
    Custo de passo = 1 (BFS -> menor nº de arestas).
    """
    
    def __init__(self, G, start_node, goal_node):

        self.G = G
        self.goal_node = goal_node

        super().__init__(initial_state = start_node, 
                         actions = self.actions_fn, 
                         transition_model = self.transition_fn, 
                         goal_test = self.goal_test_fn, 
                         step_cost = self.step_cost_fn)

    
    def actions_fn(self, state):        
        return self.G.successors(state) if hasattr(self.G, "successors") else self.G.neighbors(state)

    
    def transition_fn(self, state, action):
        return action  # ação é o próprio vizinho

    
    def goal_test_fn(self, state):
        return state == self.goal_node

    
    def step_cost_fn(self, state, action):
        return 1.0  # cada aresta custa 1
        

def uninformed_search(Model, lat_origin, lon_origin, lat_goal, lon_goal, mode):
    
    G = graph(lat_origin, lon_origin, lat_goal, lon_goal, mode=mode, margin=600)
    
    # definindo os nós mais próximos das coordenadas:
    start = ox.nearest_nodes(G, lon_origin, lat_origin)
    goal  = ox.nearest_nodes(G, lon_goal, lat_goal)
    
    print("Start node ID:", start)
    print("Goal node ID:", goal)
    
    # definindo o problema de busca:
    problem = MapProblem(G, start_node=start, goal_node=goal)
    
    # definindo o modelo de busca:
    model = Model(problem)
    
    # inicializando a busca:
    goal_node = model.search()
    
    # extraindo o caminho de nós da solução da busca:
    node = goal_node
    path = []
    
    while node is not None:
        path.append(node.state)    
        node = node.parent
    
    path_nodes = list(reversed(path))
    
    print(f"\n# Nós no caminho: {len(path_nodes)}  |  # arestas: {len(path_nodes)-1}\n")
    print(f"# Path nodes: {path_nodes}\n")
    
    # plotando o mapa e rota de solução:
    fig, ax = ox.plot_graph(G, show=False, close=False, node_size=0, edge_linewidth=0.8)
    ox.plot_graph_route(G, path_nodes, ax=ax, route_linewidth=4, orig_dest_size=80, show=False, close=False)
    plt.show()


def informed_search(Model, heuristic_class, lat_origin, lon_origin, lat_goal, lon_goal, mode):
    
    G = graph(lat_origin, lon_origin, lat_goal, lon_goal, mode=mode, margin=600)
    
    # definindo os nós mais próximos das coordenadas:
    start = ox.nearest_nodes(G, lon_origin, lat_origin)
    goal  = ox.nearest_nodes(G, lon_goal, lat_goal)
    
    print("Start node ID:", start)
    print("Goal node ID:", goal)
    
    # definindo o problema de busca:
    problem = MapProblem(G, start_node=start, goal_node=goal)

    # definindo a função heurística:
    heuristic = heuristic_class(G, goal)
    
    # definindo o modelo de busca:
    model = Model(problem, heuristic.fn)
    
    # inicializando a busca:
    goal_node = model.search()
    
    # extraindo o caminho de nós da solução da busca:
    node = goal_node
    path = []
    
    while node is not None:
        path.append(node.state)    
        node = node.parent
    
    path_nodes = list(reversed(path))
    
    print(f"\n# Nós no caminho: {len(path_nodes)}  |  # arestas: {len(path_nodes)-1}\n")
    print(f"# Path nodes: {path_nodes}\n")
    
    # plotando o mapa e rota de solução:
    fig, ax = ox.plot_graph(G, show=False, close=False, node_size=0, edge_linewidth=0.8)
    ox.plot_graph_route(G, path_nodes, ax=ax, route_linewidth=4, orig_dest_size=80, show=False, close=False)
    plt.show()

