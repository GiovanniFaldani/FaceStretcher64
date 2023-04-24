/*uniform int mode;   // Rendering mode
uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess
// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;
uniform vec3 lightPos; // Light position
varying vec4 color; //color
*/

Constants {
    int mode;
    float Ka;   // Ambient reflection coefficient
    float Kd;   // Diffuse reflection coefficient
    float Ks;   // Specular reflection coefficient
    float shininessVal; // Shininess
    // Material color
    vec3 ambientColor;
    vec3 diffuseColor;
    vec3 specularColor;
    vec3 lightPos; // Light position

};

out vec4 color; //color

vec4 lovrmain(){

  vec4 vertPos4 = VertexPosition;
  vec3 vertPos = vec3(vertPos4) / vertPos4.w;
  vec3 normalInterp = vec3(NormalMatrix * VertexNormal);
  //gl_Position = Projection * vertPos4;

  vec3 N = normalize(normalInterp);
  vec3 L = normalize(lightPos - vertPos);
  // Lambert's cosine law
  float lambertian = max(dot(N, L), 0.0);
  float specular = 0.0;
  if(lambertian > 0.0) {
    vec3 R = reflect(-L, N);      // Reflected light vector
    vec3 V = normalize(-vertPos); // Vector to viewer
    // Compute the specular term
    float specAngle = max(dot(R, V), 0.0);
    specular = pow(specAngle, shininessVal);
  }
  color = vec4(Ka * ambientColor +
               Kd * lambertian * diffuseColor +
               Ks * specular * specularColor, 1.0);

  // only ambient
  if(mode == 2) color = vec4(Ka * ambientColor, 1.0);
  // only diffuse
  if(mode == 3) color = vec4(Kd * lambertian * diffuseColor, 1.0);
  // only specular
  if(mode == 4) color = vec4(Ks * specular * specularColor, 1.0);

  return DefaultPosition;
}
