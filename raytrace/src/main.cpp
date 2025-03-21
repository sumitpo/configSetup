#include <argparse/argparse.hpp> // Include the argparse library
#include <assimp/Importer.hpp>   // C++ importer interface
#include <assimp/postprocess.h>  // Post processing flags
#include <assimp/scene.h>        // Output data structure
#include <iostream>
#include <spng.h>
#include <vector>

void write_png_file(const char *filename, int width, int height,
                    const std::vector<unsigned char> &pixels) {
  FILE *fp = fopen(filename, "wb");
  if (!fp) {
    std::cerr << "Could not open file " << filename << " for writing\n";
    return;
  }

  spng_ctx *ctx = spng_ctx_new(SPNG_CTX_ENCODER);
  if (!ctx) {
    std::cerr << "Could not create SPNG context\n";
    fclose(fp);
    return;
  }

  // Set the output file
  spng_set_png_file(ctx, fp);

  // Configure the image header
  struct spng_ihdr ihdr = {.width = static_cast<uint32_t>(width),
                           .height = static_cast<uint32_t>(height),
                           .bit_depth = 8,
                           .color_type = SPNG_COLOR_TYPE_TRUECOLOR_ALPHA,
                           .compression_method = 0,
                           .filter_method = 0,
                           .interlace_method = 0};

  int ret = spng_set_ihdr(ctx, &ihdr);
  if (ret) {
    std::cerr << "spng_set_ihdr() error: " << spng_strerror(ret) << "\n";
    spng_ctx_free(ctx);
    fclose(fp);
    return;
  }

  // Write the image data
  ret = spng_encode_image(ctx, pixels.data(), pixels.size(), SPNG_FMT_PNG,
                          SPNG_ENCODE_FINALIZE);
  if (ret) {
    std::cerr << "spng_encode_image() error: " << spng_strerror(ret) << "\n";
  }

  spng_ctx_free(ctx);
  fclose(fp);
}

void processMesh(aiMesh *mesh) {
  std::cout << "Mesh: " << mesh->mName.C_Str() << std::endl;
  std::cout << "  Vertices: " << mesh->mNumVertices << std::endl;
  std::cout << "  Faces: " << mesh->mNumFaces << std::endl;

  // Process vertices
  for (unsigned int i = 0; i < mesh->mNumVertices; i++) {
    aiVector3D vertex = mesh->mVertices[i];
    std::cout << "    Vertex " << i << ": (" << vertex.x << ", " << vertex.y
              << ", " << vertex.z << ")" << std::endl;
  }

  // Process faces
  for (unsigned int i = 0; i < mesh->mNumFaces; i++) {
    aiFace face = mesh->mFaces[i];
    std::cout << "    Face " << i << ": ";
    for (unsigned int j = 0; j < face.mNumIndices; j++) {
      std::cout << face.mIndices[j] << " ";
    }
    std::cout << std::endl;
  }
}

void processMaterial(aiMaterial *material) {
  aiString name;
  material->Get(AI_MATKEY_NAME, name);
  std::cout << "Material: " << name.C_Str() << std::endl;

  // Process material properties (e.g., diffuse color)
  aiColor3D diffuseColor;
  if (material->Get(AI_MATKEY_COLOR_DIFFUSE, diffuseColor) == AI_SUCCESS) {
    std::cout << "  Diffuse Color: (" << diffuseColor.r << ", "
              << diffuseColor.g << ", " << diffuseColor.b << ")" << std::endl;
  }
}

void processNode(aiNode *node, const aiScene *scene) {
  std::cout << "Node: " << node->mName.C_Str() << std::endl;

  // Process all meshes in this node
  for (unsigned int i = 0; i < node->mNumMeshes; i++) {
    aiMesh *mesh = scene->mMeshes[node->mMeshes[i]];
    processMesh(mesh);
  }

  // Process all materials in this node
  for (unsigned int i = 0; i < scene->mNumMaterials; i++) {
    aiMaterial *material = scene->mMaterials[i];
    processMaterial(material);
  }

  // Recursively process child nodes
  for (unsigned int i = 0; i < node->mNumChildren; i++) {
    processNode(node->mChildren[i], scene);
  }
}

// Function to parse command-line arguments
void parse_arguments(int argc, char *argv[],
                     argparse::ArgumentParser &program) {
  /*
  // Create an ArgumentParser object
  argparse::ArgumentParser program("my_program");
  */

  // Add arguments
  program.add_argument("--input").help("Path to the input file").required();

  program.add_argument("--output")
      .help("Path to the output file")
      .default_value(std::string("output.txt"));

  program.add_argument("--verbose")
      .help("Enable verbose output")
      .default_value(false)
      .implicit_value(true);

  // Parse the command-line arguments
  try {
    program.parse_args(argc, argv);
  } catch (const std::runtime_error &err) {
    std::cerr << err.what() << std::endl;
    std::cerr << program;
    exit(1); // Exit the program if parsing fails
  }
}

int main(int argc, char *argv[]) {
  argparse::ArgumentParser program("demo");
  parse_arguments(argc, argv, program);

  // Access the parsed arguments
  auto input_path = program.get<std::string>("--input");
  auto output_path = program.get<std::string>("--output");
  auto verbose = program.get<bool>("--verbose");

  // Create an instance of the Importer class
  Assimp::Importer importer;

  // Load the model from file
  const aiScene *scene =
      importer.ReadFile(input_path, aiProcess_Triangulate | aiProcess_FlipUVs);

  // Check if the model was loaded successfully
  if (!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE ||
      !scene->mRootNode) {
    std::cerr << "ERROR::ASSIMP::" << importer.GetErrorString() << std::endl;
    return -1;
  }

  // Process the loaded model
  std::cout << "Model loaded successfully!" << std::endl;
  processNode(scene->mRootNode, scene);

  return 0;
}
