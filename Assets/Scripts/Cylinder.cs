using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ProceduralModeling {

    // public class Cylinder : ProceduralModelingBase {

    //    [SerializeField, Range(0.1f, 10f)] protected float height = 3f, radius = 1f;
    //    [SerializeField, Range(3, 30)] protected int segments = 16;

    //    [SerializeField] bool openEnded = true;

    //     protected override Mesh Build() {

    //         var mesh = new Mesh();

    //         var vertices = new List<Vector3>();
    //         var uv = new List<Vector2>();
    //         var normals = new List<Vector3>();
    //         var triangles = new List<int>();

    //         float top = height * 0.5f, bottom = -height * 0.5f;

    //         GenerateCap(segments + 1, top, bottom, radius, vertices, uv, normals, openEnded);


            
    //    }

    //     void GenerateCap(int segments, float top, float bottom, float radius, List<Vector3> vetices, List<Vector2> uvs, List<Vector3> normals, bool side) {
    //         for (int i = 0; i < segments; i++) {
    //             // 0.0 ~ 1.0
    //             float ratio = (float)i / (segments - 1);

    //             // 0.0 ~ 2 π
    //             float rad = ratio * Mathf.PI * 2f;

    //             // 円周に沿って頂点を配置する
    //             float cos = Mathf.Cos(rad), sin = Mathf.Sin(rad);
    //             float x = cos * radius, z = sin * radius;
    //             Vector3 tp = new Vector3(x, top, z), bp = new Vector3(x, bottom, z);

    //             vetices.Add(tp);
    //             uvs.Add(new Vector2(ratio, 1f));
    //         }
    //     }
            
    // }
}
