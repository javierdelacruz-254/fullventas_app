class AppRoutes {
  static const String baseUrl =
      'http://192.168.1.3/mystore/gull_ventas_php_project';
  static const String postCalificacion =
      '$baseUrl/insert_calificacion_instructor.php';
  static const String getCategorias = '$baseUrl/get_categories.php';
  static const String getDescuentos = '$baseUrl/get_descuentos.php';
  static const String getDestinaton = '$baseUrl/get_destination_type.php';
  static const String getDisciplinas = '$baseUrl/get_disciplinas.php';
  static const String getEstrategia = '$baseUrl/get_estrategia_venta.php';
  static String getEstrategiaImg(int estrategiaId) =>
      '$baseUrl/get_estrategia_ventas_image_id.php?id=$estrategiaId';
  static const String getGrupoMusculares = '$baseUrl/get_grupos_musculares.php';
  static String getProductImage(int productId) =>
      '$baseUrl/get_productos_image_id.php?id=$productId';
  static const String getIntructor = '$baseUrl/get_instructor.php';
  static const String login = '$baseUrl/login.php';
  static String getMaquinas(int idGrupo) =>
      '$baseUrl/get_maquinas.php?id_grupo=$idGrupo';
  static const String postPaseLibreCliente =
      '$baseUrl/insert_clientes_paselibre.php';
  static const String getPaseLibre = '$baseUrl/get_paselibre_byId.php';
  static const String getPlanes = '$baseUrl/get_planes.php';
  static String getPlanesImg(int planId) =>
      '$baseUrl/get_planes_image_id.php?id=$planId';
  static const String getProducts = '$baseUrl/get_productos_category_1.php';
  static const String getPublicaciones = '$baseUrl/get_publicaciones.php';
  static const String getScreen = '$baseUrl/get_info_screen.php';
  static const String getServices = '$baseUrl/get_productos_category_2.php';
  static const String getSettingVideo = '$baseUrl/get_video_destacado.php';
  static String getSizeId(int sizeId) =>
      '$baseUrl/get_sizes.php?size_id=$sizeId';
  static const String getSlider = '$baseUrl/get_slider_home.php';
  static const String getSucursales = '$baseUrl/get_sucursale.php';
  static const String insertSugerencias = '$baseUrl/insert_suge_reco.php';
  static const String getSugerenciasType = '$baseUrl/get_sugerencias_type.php';
  static const String getUser = '$baseUrl/get_users_by_id.php';
  static const String getVideos = '$baseUrl/get_videos.php';
  static String getMusculosById(int idGrupo) =>
      '$baseUrl/get_musculos.php?id_grupo=$idGrupo';
  static String getPaseLibreCliente(String nombre) =>
      '$baseUrl/get_clientes_paselibre.php?nombre=$nombre';
  static String getRutinas(int idCliente) =>
      '$baseUrl/get_rutinas.php?id_cliente=$idCliente';
  static const String getUserInfo = '$baseUrl/get_info_user_gym.php';
  static const String getDepartamentos =
      '$baseUrl/get_departamentos.php?tipo=departamentos';
  static String getProvincias(String idDepartamento) =>
      '$baseUrl/get_departamentos.php?tipo=provincias&id_departamento=$idDepartamento';
  static String getDistritos(String idProvincia) =>
      '$baseUrl/get_departamentos.php?tipo=distritos&id_provincia=$idProvincia';
}
