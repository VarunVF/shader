# 3D Graphics Transformations

These transformations apply to 3D graphics in general.



| From Space  | To Space      | Transformation     | Explanation |
|-------------|---------------|--------------------|-------------|
| -           | Local Space   | -                  | The object's local coordinate system |
| Local Space | World Space   | Model Matrix       | Place the object in the world |
| World Space | View Space    | View Matrix        | Place the world from the camera's POV |
| View Space  | Clip Space    | Projection Matrix  | Project 3D coordinates onto a 2D plane, and prepare for slipping |
| Clip Space  | NDC Space     | Perspective Divide | Divide by homogenous the coordinate `w` to get vertices in $[-1.0, 1.0]$ |
| NDC Space   | Screen Space  | Viewport Transform | Map NDC coords to screen coords, using the settings of `glViewport` |


# Minecraft Shader Specifics

## Spaces

Minecraft uses some additional spaces:
- Model Space
    - This is whatever coordinate space the vertex position attribute is sent in (local space).
- View Space
    - Axes change with the camera direction
- Player Space
    - Similar to view space, but axes are fixed to the world's axes.
- Feet and Eye Player Space
    - In feet player space, the origin remains locked to the player's head position, whereas in eye player space, effects like view bobbing are accounted for, meaning that the origin is locked to the camera.
- World Space
    - Minecraft's actual coordinate system
    - Directionally equivalent to player space
    

## Inverse Matrices

Iris provides us with several inverse matrices which perform the backwards operation.

For example, if `gbufferModelView` transforms from player to view/eye space, then `gbufferModelViewInverse` transforms from view/eye space to player space.

## `ftransform()`

`ftransform()` is a glsl function that transforms the vertex position from model to clip space (skipping over world space). It is actually deprecated but the Iris patcher updates it to the relevant modern mode.
