#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

#define PI 3.1415926538

// change this variable name to your Edition's name
// YOU MUST USE THIS VARIABLE IN THE vec4 effect AT LEAST ONCE
// ^^ CRITICALLY IMPORTANT (IDK WHY)
extern MY_HIGHP_OR_MEDIUMP vec2 lenticular;

extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

extern MY_HIGHP_OR_MEDIUMP float tilt;
extern Image image;

// the following four vec4 are (as far as I can tell) required and shouldn't be changed

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

    float t = time * 10.0 + 2003.;
    vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
    
    vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
    vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
    vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

float distanceBetweenColors(vec3 colorA, vec3 colorB) {
    return length(clamp(colorA, 0.0, 1.0) - clamp(colorB, 0.0, 1.0));
}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 hueshift(vec3 rgb, float adjustment)
{
    vec3 hsv = rgb2hsv(rgb);
    hsv.x += adjustment;
    return hsv2rgb(hsv);
}

vec3 saturation(vec3 rgb, float adjustment)
{
    // Algorithm from Chapter 16 of OpenGL Shading Language
    const vec3 W = vec3(0.1125, 0.2154, 0.0221);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

// this is what actually changes the look of card
vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    
    // texture_coords = (pixel coords on atlas) / (atlas size) | Ranges from 0 to 1, 0 = (0,0) and 1 = (atlas width, atlas height)
    // texture_details = (joker x, joker y, joker w, joker h)  | x and y are whole numbers referring to rows and columns on the atlas. w and h are pixel sizes
    // image_details  = atlas size                             | Pixel sizes

    vec2 atlas_pixel_coords = texture_coords * image_details; // Pixel coords on the entire atlas.
    vec2 card_size = texture_details.ba;                      // Pixel size of a card.
    vec2 atlas_grid_coords = texture_details.xy;              // Coords on the atlas grid. First joker is (0,0), 2nd is (1,0), and so on.
    vec2 corner_pos = atlas_grid_coords * card_size;          // Pixel coords of the top left corner of this card on the entire atlas. For first card, always (0,0), and so on.
    vec2 card_pixel_coords = atlas_pixel_coords - corner_pos; // Pixel coords relative to just this card. Top left corner is (0,0), etc.

    // card_pixel_coords + corner_pos = atlas_pixel_coords

    vec2 uv = card_pixel_coords/card_size;

    float timer = lenticular.y;

    bool transparent = false;
    // float wave1 = (sin((card_pixel_coords.x*15.0/card_size.x)+(timer    ))+1.0)/2.0; // Hopefully this should range from 0 to 1
    // float wave2 = (cos((card_pixel_coords.x*8.6 /card_size.x)-(timer/1.5))+1.0)/2.0;
    // float wave3 = (sin((card_pixel_coords.x*3.6 /card_size.x)-(timer*1.4))+1.0)/2.0;
    // float wave_sum = (wave1 + wave2 + wave3)/3;
    // //texture_coords.y = texture_coords.y - ((card_pixel_coords.y/card_size.y)*wave_sum*0.5);

    // float subtract = wave_sum * card_pixel_coords.y * 0.25;

    // texture_coords.y = (card_pixel_coords.y + corner_pos.y + subtract) / image_details.y;

    //uv = card_pixel_coords/card_size;

    if (texture_coords.y > ((corner_pos+card_size)/image_details).y) {
        // texture_coords.y = 0.99;
        transparent = true;
    }

    uv = card_pixel_coords/card_size;

    // turns the texture into pixels
    vec4 tex = Texel(texture, texture_coords);
    vec4 pixelColor = tex.rgba;
    uv = card_pixel_coords/card_size;

    // Dummy, doesn't do anything but at least it makes the shader useable
    if (uv.x > uv.x * 2){
        uv = lenticular;
    }

    // pixelColor.a = min(pixelColor.a,0.75+(pixelColor.g*0.15));
    // pixelColor.r = pixelColor.r * 0.9;
    // pixelColor.g = pixelColor.g;
    // pixelColor.b = pixelColor.b * 0.6;
    
    if (transparent) {
        pixelColor.a = 0;
    }

    // pixelColor.r = lenticular.x / 1.5;
    // pixelColor.g = lenticular.x / 1.5;
    // pixelColor.b = lenticular.x / 1.5;

    if (mod(card_pixel_coords.x, 5) <= (tilt+0.1)*5) {
        pixelColor.rgb = Texel(image, uv).rgb;
        pixelColor.a = pixelColor.a * Texel(image, uv).a;
    }

    // vec2 newUV = uv;
    // newUV.x = ( sin(uv.y * 1.54 * PI + time) * cos(uv.y * 1.31 * PI + time) * 0.1 );
    // newUV.y = ( cos(uv.x * 1.74 * PI + time) * -sin(uv.x * 1.64 * PI + time) * 0.1 );

    // required
    return dissolve_mask(pixelColor.rgba, texture_coords, uv);
}

// for transforming the card while your mouse is on it
extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif