customVertex = [[
    vec4 lovrmain()
    {
        return Projection * View * Transform * VertexPosition;
    }
]]

gradientShader = [[
    Constants {
        vec4 color1;
        vec4 color2;
    };

    // Apply a vertical gradient using the 2 colors from the constants:

    vec4 lovrmain(){
        return color1 + color2 * dot(Normal, vec3(0, 1, 0));
    }
]]

customFragment = [[
    vec4 lovrmain()
    {
        return Color * getPixel(ColorTexture, UV);
    }
]]