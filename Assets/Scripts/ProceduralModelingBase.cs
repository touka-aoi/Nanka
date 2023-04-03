using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ProceduralModeling {
  public enum ProceduralModelingMaterial {
    Standard,
    UV,
    Normal,

    Wireframe,
  };

  [RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
  [ExecuteInEditMode]
  public abstract class ProceduralModelingBase : MonoBehaviour {

    public MeshFilter Filter {
      get {
        if (filter == null) {
          filter = GetComponent<MeshFilter>();
        }
        return filter;
      }
    }

    public MeshRenderer Renderer {
      get {
        if (renderer == null) {
          renderer = GetComponent<MeshRenderer>();
        }
        return renderer;
      }
    }

    MeshFilter filter;
    new MeshRenderer renderer;

    [SerializeField] protected ProceduralModelingMaterial materialType = ProceduralModelingMaterial.UV;

    protected virtual void Start() {
      ReBuild();
    }

    public void ReBuild() {
      if (Filter.sharedMesh != null) {
        // すでにメッシュがある場合は破棄する
        if (Application.isPlaying) {
          // 実行中の場合
          Destroy(Filter.sharedMesh);
        } else {
          // エディタ上の場合
          DestroyImmediate(Filter.sharedMesh);
        }
      }

      // メッシュを生成する
      Filter.sharedMesh = Build();
      Renderer.sharedMaterial = LoadMaterial(materialType);
    }

    protected virtual Material LoadMaterial(ProceduralModelingMaterial type) {
      switch (type) {
        case ProceduralModelingMaterial.UV:
          return Resources.Load<Material>("Materials/UV");
        case ProceduralModelingMaterial.Normal:
          return Resources.Load<Material>("Materials/Normal");
        case ProceduralModelingMaterial.Wireframe:
          return Resources.Load<Material>("Materials/Wireframe");
        default:
          return Resources.Load<Material>("Materials/Standard");
      }
    }

    protected abstract Mesh Build();
  }
}