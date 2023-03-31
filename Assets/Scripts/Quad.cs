using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ProceduralModeling {

    public class Quad: ProceduralModelingBase {

        [SerializeField, Range(0.1f, 10f)] protected float size = 1f;

        protected override Mesh Build() {
            Mesh mesh = new Mesh();

            float halfSize = size * 0.5f;

            // Quadの頂点データ
            Vector3[] vertices = new Vector3[] {
                new Vector3(-halfSize, halfSize, 0f),
                new Vector3(halfSize, halfSize, 0f),
                new Vector3(halfSize, -halfSize, 0f),
                new Vector3(-halfSize, -halfSize, 0f),
            };

            // QuadのUV
            Vector2[] uv = new Vector2[] {
                new Vector2(0f, 0f),
                new Vector2(1f, 0f),
                new Vector2(1f, 1f),
                new Vector2(0f, 1f),
            };

            // Quadの法線
            Vector3[] normals = new Vector3[] {
                new Vector3(0f, 0f, -1f),
                new Vector3(0f, 0f, -1f),
                new Vector3(0f, 0f, -1f),
                new Vector3(0f, 0f, -1f),
            };

            // Quadの頂点インデックス
            int[] tri = new int[] {
                0, 1, 2,
                2, 3, 0
            };

            mesh.vertices = vertices;
            mesh.uv = uv;
            mesh.normals = normals;
            mesh.triangles = tri;

            // バウンディングボックスの計算
            mesh.RecalculateBounds();

            return mesh;
        }
    }


}