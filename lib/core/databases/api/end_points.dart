class EndPoints {

  static const String baseUrl = "https://select.sy/api";
  // "https://select.sy/api";
  // "http://16.24.232.4:8000";
  // "http://192.168.1.56:8000/api";


  //Auth
  static const String login = "/admin/auth/login";
  static const String changePassword = "/admin/auth/change-password";

  //Main screen

  //Restaurants
  static const String restaurants = "/admin/restaurants/GetAll";
  static const String restaurantById = "/admin/restaurants/GetById";
  static const String updateRestaurant = "/admin/restaurants/Update";
  static const String addRestaurant = "/admin/restaurants/Create";

  //Tables
  static const String getTablesByRestaurant = "/admin/restaurantTables/GetTablesByRestaurantId";
  static const String addTable = "/admin/restaurantTables/AddTable";
  static const String deleteTable = "/admin/restaurantTables/DeleteTable";
  static const String toggleTableStatus = "/admin/restaurantTables/ToggleActive";
  static const String getSectionsByRestaurant = "/admin/sections/GetAll";
  static const String addSection = "/admin/sections/AddSection";
  static const String reserveTable = "/admin/restaurantTables/ReserveTable";

  //Menu Management - Catalog
  static const String getMainCategories = "/admin/categories/GetAll";
  static const String getItemsByCategory = "/admin/items/GetAll";
  static const String addCategory = "/admin/categories/AddCategory";
  static const String addItem = "/admin/items/Add";
  static const String deleteItem = "/admin/items/Delete";
  static const String toggleItemActive = "/admin/items/ToggleActive";
  static const String toggleCategoryStatus = "/admin/categories/ToggleActive";

  //Menu Management - Modifiers
  static const String getModifiersGroups = "/admin/modifiergroups/GetAll";
  static const String getModifiersByGroup = "/admin/modifiers/GetAll";
  static const String toggleModifierStatus = "/admin/modifiers/ToggleActive";
  static const String deleteModifiersGroup = "/admin/modifiergroups/Delete";
  static const String addModifier = "/admin/modifiers/Add";
  static const String addModifiersGroup = "/admin/modifiergroups/Add";

  //Menu Management - Combos
  static const String getAllCombos = "/admin/combos/GetAll";
  static const String createAndUpdateCombo = "/admin/combos/Save";
  static const String toggleComboStatus = "/admin/combos/ToggleActive";
  static const String deleteCombo = "/admin/combos/Delete";

  //Promotions
  static const String getPromotions = "/admin/promotions/GetAll";
  static const String togglePromotionStatus = "/admin/promotions/ToggleActive";
  static const String addPromotion = "/admin/promotions/AddCategory";
  static const String deletePromotion = "/admin/promotions/Delete";
  static const String getPromotionItems = "/admin/promotionItems/GetAll";

  //Error Logs
  static const String getErrorLogs = "/admin/generalAPIs/GetErroeLog";

  //Taxes
  static const String getAllTaxTypes = "/admin/taxes/types/GetAll";
  static const String createTaxType = "/admin/taxes/types/Create";
  static const String deleteTaxType = "/admin/taxes/types/Delete";
  static const String updateTaxType = "/admin/taxes/types/Update";
  static const String getAllTaxRules = "/admin/taxes/rules/GetAll";
  static const String createTaxRule = "/admin/taxes/rules/Create";
  static const String deleteTaxRule = "/admin/taxes/rules/Delete";
  static const String updateTaxRule = "/admin/taxes/rules/Update";

  //Users
  static const String info = "/admin/auth/me";
  static const String addUser = "/admin/auth/Add";
  static const String getAllUsers = "/admin/auth/GetAllUsers";

  //Orders
  static const String getAllOrders = "/admin/orders/GetAll";
  static const String updateOrderStatus = "/admin/orders/updatestatus";

}

/*class ApiKey {
  static String id = "id";
  static String name = "name";
  static String title = "title";
  static String completed = "completed";
}*/
