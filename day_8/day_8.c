#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <limits.h>

#define MAX_POINTS 1000

typedef struct {
	int x, y, z;
} Point;

typedef struct {
	int u; // index of first point
	int v; // index of second point
	long long dist2; // squared distance
} Edge;

typedef struct {
	int *parent;
	int *size;
	int count;
} DSU;

DSU* create_dsu(int n) {
	DSU* dsu = (DSU*)malloc(sizeof(DSU));
	dsu->parent = (int*)malloc(n * sizeof(int));
	dsu->size = (int*)malloc(n * sizeof(int));
	dsu->count = n;
	for (int i = 0; i < n; i++) {
		dsu->parent[i] = i;
		dsu->size[i] = 1;
	}
	return dsu;
}

int find_set(DSU* dsu, int i) {
	if (dsu->parent[i] == i)
		return i;
	dsu->parent[i] = find_set(dsu, dsu->parent[i]);
	return dsu->parent[i];
}

void union_sets(DSU* dsu, int i, int j) {
	int root_i = find_set(dsu, i);
	int root_j = find_set(dsu, j);
	if (root_i != root_j) {
		if (dsu->size[root_i] < dsu->size[root_j]) {
			int temp = root_i;
			root_i = root_j;
			root_j = temp;
		}
		dsu->parent[root_j] = root_i;
		dsu->size[root_i] += dsu->size[root_j];
		dsu->count--;
	}
}

void free_dsu(DSU* dsu) {
	free(dsu->parent);
	free(dsu->size);
	free(dsu);
}

Point* read_points(const char* filename, int* count) {
	FILE* fp = fopen(filename, "r");
	if (!fp) return NULL;

	Point* points = (Point*)malloc(MAX_POINTS * sizeof(Point));
	*count = 0;

	char line[256];
	while (fgets(line, sizeof(line), fp)) {
		if (*count >= MAX_POINTS) {
			break;
		}
		if (sscanf(line, "%d,%d,%d", &points[*count].x, &points[*count].y, &points[*count].z) == 3) {
			(*count)++;
		}
	}
	fclose(fp);
	return points;
}

int compare_edges(const void* a, const void* b) {
	Edge* edgeA = (Edge*)a;
	Edge* edgeB = (Edge*)b;
	if (edgeA->dist2 < edgeB->dist2) return -1;
	if (edgeA->dist2 > edgeB->dist2) return 1;
	return 0;
}

int compare_ints_desc(const void* a, const void* b) {
	return (*(int*)b - *(int*)a);
}


int main() {
	int n;
	Point* points = read_points("input.txt", &n);
	// printf("Read %d points.\n", n);

	int max_edges = n * (n - 1) / 2;
	Edge* edges = (Edge*)malloc(max_edges * sizeof(Edge));
	int edge_count = 0;

	for (int i = 0; i < n; i++) {
		for (int j = i + 1; j < n; j++) {
			long long dx = points[i].x - points[j].x;
			long long dy = points[i].y - points[j].y;
			long long dz = points[i].z - points[j].z;
			edges[edge_count].u = i;
			edges[edge_count].v = j;
			edges[edge_count].dist2 = dx*dx + dy*dy + dz*dz;
			edge_count++;
		}
	}

	qsort(edges, edge_count, sizeof(Edge), compare_edges);

	DSU* dsu = create_dsu(n);
	int target_connections = (n < 100) ? 10 : 1000;
	int part1_done = 0;

	for (int i = 0; i < edge_count; i++) {
		if (i == target_connections && !part1_done) {
			int* circuit_sizes = (int*)malloc(n * sizeof(int));
			int num_circuits = 0;

			for (int k = 0; k < n; k++) {
				if (dsu->parent[k] == k) {
					circuit_sizes[num_circuits++] = dsu->size[k];
				}
			}

			qsort(circuit_sizes, num_circuits, sizeof(int), compare_ints_desc);

			long long result = 1;
			int count_to_multiply = num_circuits < 3 ? num_circuits : 3;

			for (int k = 0; k < count_to_multiply; k++) {
				result *= circuit_sizes[k];
			}
			printf("Part 1 Result: %lld\n", result);
			free(circuit_sizes);
			part1_done = 1;
		}

		int u = edges[i].u;
		int v = edges[i].v;

		if (find_set(dsu, u) != find_set(dsu, v)) {
			union_sets(dsu, u, v);
			if (dsu->count == 1) {
				long long result = (long long)points[u].x * points[v].x;
				printf("Part 2 Result: %lld\n", result);
				break;
			}
		}
	}

	free(points);
	free(edges);
	free_dsu(dsu);

	return 0;
}