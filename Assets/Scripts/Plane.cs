using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ProceduralModeling {

    public class Plane : ProceduralModelingBase {
        
        [SerializeField, Range(2, 30)] protected int widthSegments = 8, hegithSegments = 8;
        [SerializeField, Range(0.1f, 10f)] protected float width = 1f, height = 1f;

        protected override Mesh Build() {

            Mesh mesh = new Mesh();

            var vertices = new List<Vector3>();
            var uv = new List<Vector2>();
            var normals = new List<Vector3>();

            // 頂点の位置間隔
            var winv = 1f / (widthSegments - 1);
            var hinv = 1f / (hegithSegments - 1);

            for (int y = 0; y < hegithSegments; y++) {
                // 縦の間隔 (0.0 ~ 1.0)
                var ry = y * hinv;

                for (int x = 0; x < widthSegments; x++) {
                    // 横の間隔 (0.0 ~ 1.0)
                    var rx = x * winv;

                    // 頂点の位置
                    vertices.Add(new Vector3(
                        (rx - 0.5f) * width, // 中心に来るように調整
                        0f,
                        (0.5f - ry) * height // 中心に来るように調整
                    ));

                    // UV
                    // 0~1の間隔からUVを設定
                    uv.Add(new Vector2(rx, ry));

                    // 法線
                    normals.Add(new Vector3(0f, 1f, 0f));
                }
            }

            var triangles = new List<int>();

            // 頂点インデックスの作成
            for (int y = 0; y < hegithSegments - 1; y++) {
                for (int x = 0; x < widthSegments -1; x++) {
                    int index = y * widthSegments + x;
                    var i0 = index;
                    var i1 = index + 1;
                    var i2 = index + 1 + widthSegments;
                    var i3 = index + widthSegments;

                    triangles.Add(i0);
                    triangles.Add(i1);
                    triangles.Add(i2);

                    triangles.Add(i2);
                    triangles.Add(i3);
                    triangles.Add(i0);
                }
            }

            mesh.vertices = vertices.ToArray();
            mesh.uv = uv.ToArray();
            mesh.normals = normals.ToArray();
            mesh.triangles = triangles.ToArray();

            mesh.RecalculateBounds();

            return mesh;
        }

    }

}