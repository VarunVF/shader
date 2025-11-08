# Shader Notes

## Naming

There are vertex shaders and fragment shaders for each stage of rendering.

| Shader          | Type            |
|-----------------|-----------------|
| `composite.vsh` | Vertex Shader   |
| `composite.fsh` | Fragment Shader |

## Rendering

### Deferred Shading

Deferred shading is when heavy rendering such as lighting is deferred to a later stage in the pipeline.

**G-buffers** refer to geometry buffers used for deferred shading. They store information like normals, depth, and color.

In the first pass (geometry pass), the g-buffers are populated with various info about the geometry. In the second pass (lighting pass), a simpler rendering pass for lighting calculations is performed.

### Composite

The `composite` pass is a fullscreen pass which runs just after all of the gbuffer programs have rendered.
