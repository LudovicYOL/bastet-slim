<?php

require_once '../include/DbHandler.php';
require_once '../include/PassHash.php';
require '.././libs/Slim/Slim.php';

\Slim\Slim::registerAutoloader();
$app = new \Slim\Slim();
// ID utilisateur - variable globale
$user_id = NULL;
/**
 * Vérification params nécessaires posté ou non
 */
function verifyRequiredParams($required_fields) {
    $error = false;
    $error_fields = "";
    $request_params = array();
    $request_params = $_REQUEST;

    // Manipulation paramsde la demande PUT
    if ($_SERVER['REQUEST_METHOD'] == 'PUT') {
        $app = \Slim\Slim::getInstance();
        parse_str($app->request()->getBody(), $request_params);
    }
    foreach ($required_fields as $field) {
        if (!isset($request_params[$field]) || strlen(trim($request_params[$field])) <= 0) {
            $error = true;
            $error_fields .= $field . ', ';
        }
    }
    if ($error) {
        //Champ (s) requis sont manquants ou vides
        // echo erreur JSON et d'arrêter l'application
        $response = array();
        $app = \Slim\Slim::getInstance();
        $response["error"] = true;
        $response["message"] = 'Champ(s) requis ' . substr($error_fields, 0, -2) . ' est (sont) manquant(s) ou vide(s)';
        echoRespnse(400, $response);
        $app->stop();
    }
}
/**
 * Validation adresse e-mail
 */
function validateEmail($email) {
    $app = \Slim\Slim::getInstance();
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $response["error"] = true;
        $response["message"] = "Adresse e-mail n'est pas valide";
        echoRespnse(400, $response);
        $app->stop();
    }
}
/**
 * Faisant écho à la réponse JSON au client
 * @param String $status_code  Code de réponse HTTP
 * @param Int $response response Json
 */
function echoRespnse($status_code, $response) {
    $app = \Slim\Slim::getInstance();
    // Code de réponse HTTP
    $app->status($status_code);

    // la mise en réponse type de contenu en JSON
    $app->contentType('application/json');

    echo utf8_encode(json_encode($response));
}



$app->get('/test', function () { 
    echo "Hello, World! test"; 
  });


 /**
 * Enregistrement de l'utilisateur
 * url - /register
 * methode - POST
 * params - name, email, password
 */
$app->post('/register', function() use ($app) {
    // vérifier les paramètres requises
    verifyRequiredParams(array('name', 'email', 'password'));

    $response = array();

    // lecture des params de post
    $name = $app->request->post('name');
    $email = $app->request->post('email');
    $password = $app->request->post('password');

    // valider adresse email
    validateEmail($email);

    $db = new DbHandler();
    $res = $db->createUser($name, $email, $password);

    if ($res == USER_CREATED_SUCCESSFULLY) {
        $response["error"] = false;
        $response["message"] = "Vous êtes inscrit avec succès";
    } else if ($res == USER_CREATE_FAILED) {
        $response["error"] = true;
        $response["message"] = "Oops! Une erreur est survenue lors de l'inscription";
    } else if ($res == USER_ALREADY_EXISTED) {
        $response["error"] = true;
        $response["message"] = "Désolé, cet E-mail éxiste déja";
    }
    // echo de la repense  JSON
    echoRespnse(201, $response);
});

/**
 * Login Utilisateur
 * url - /login
 * method - POST
 * params - email, password
 */
$app->post('/login', function() use ($app) {
    // vérifier les paramètres requises
    verifyRequiredParams(array('email', 'password'));

    // lecture des params de post
    $email = $app->request()->post('email');

    // valider l'adresse email
    validateEmail($email);

    $password = $app->request()->post('password');
    $response = array();

    $db = new DbHandler();
    // vérifier l'Email et le mot de passe sont corrects
    var result = $db->checkLogin($email, $password);
    if (result == "ok") {
        // obtenir l'utilisateur par email
        $user = $db->getUserByEmail($email);

        if ($user != NULL) {
            if($user["status"]==1){
                $response["error"] = false;
                $response['name'] = $user['name'];
                $response['email'] = $user['email'];
                $response['apiKey'] = $user['api_key'];
                $response['createdAt'] = $user['created_at'];
            }
            else if($user["status"]==0) {
                $response['error'] = true;
                $response['champ'] = "email";
                $response['message'] = "Votre compte n'a pas encore été validé";
            }else{
                $response['error'] = true;
                $response['champ'] = "email";
                $response['message'] = "Votre compte a été suspendu";
            }
        } else {
            // erreur inconnue est survenue
            $response['error'] = true;
            $response['champ'] = "email";
            $response['message'] = "Erreur inconnue";
        }
    } else if(result == "error") {
        // identificateurs de l'utilisateur sont erronés
        $response['error'] = true;
        $response['champ'] = "password";
        $response['message'] = 'Échec de la connexion. identificateurs incorrectes';
    } else {
        // not-found : le compte n'existe pas
        $response['error'] = true;
        $response['champ'] = "email";
        $response['message'] = 'Ce compte n\'existe pas';
    }

    echoRespnse(200, $response);
});

/**
 * Ajout de Couche intermédiaire pour authentifier chaque demande
 * Vérifier si la demande a clé API valide dans l'en-tête "Authorization"
 */
function authenticate(\Slim\Route $route) {
    // Obtenir les en-têtes de requêtes
    $headers = apache_request_headers();
    $response = array();
    $app = \Slim\Slim::getInstance();

    // Vérification de l'en-tête d'autorisation
    if (isset($headers['Authorization'])) {
        $db = new DbHandler();

        // Obtenir la clé d'api
        $api_key = $headers['Authorization'];
        // Valider la clé API
        if (!$db->isValidApiKey($api_key)) {
            //  Clé API n'est pas présente dans la table des utilisateurs
            $response["error"] = true;
            $response["message"] = "Accès Refusé. Clé API invalide";
            echoRespnse(401, $response);
            $app->stop();
        } else {
            global $user_id;
            // Obtenir l'ID utilisateur (clé primaire)
            $user_id = $db->getUserId($api_key);
        }
    } else {
        // Clé API est absente dans la en-tête
        $response["error"] = true;
        $response["message"] = "Clé API est manquante";
        echoRespnse(400, $response);
        $app->stop();
    }
}

/**
 *Création d'une nouvelle tâche dans db
 * method POST
 * params - name
 * url - /tasks/
 */
$app->post('/tasks', 'authenticate', function() use ($app) {
    // vérifier les paramètres requises
    verifyRequiredParams(array('task'));

    $response = array();
    $task = $app->request->post('task');

    global $user_id;
    $db = new DbHandler();

    //Création d'une nouvelle tâche
    $task_id = $db->createTask($user_id, $task);

    if ($task_id != NULL) {
        $response["error"] = false;
        $response["message"] = "Tâche créé avec succès";
        $response["task_id"] = $task_id;
        echoRespnse(201, $response);
    } else {
        $response["error"] = true;
        $response["message"] = "Impossible de créer la tâche. S'il vous plaît essayer à nouveau";
        echoRespnse(200, $response);
    }
});

/**
 *Lister toutes les tâches d'un utilisateur particulier
 * method GET
 * url /tasks
 */
$app->get('/tasks', 'authenticate', function() {
    global $user_id;
    $response = array();
    $db = new DbHandler();

    // aller chercher toutes les tâches de l'utilisateur
    $result = $db->getAllUserTasks($user_id);

    $response["error"] = false;
    $response["tasks"] = array();

    // boucle au travers du résultat et de la préparation du tableau des tâches
    while ($task = $result->fetch_assoc()) {
        $tmp = array();
        $tmp["id"] = $task["id"];
        $tmp["task"] = $task["task"];
        $tmp["status"] = $task["status"];
        $tmp["createdAt"] = $task["created_at"];
        array_push($response["tasks"], $tmp);
    }

    echoRespnse(200, $response);
});

/**
 *Lister toutes les tâches d'un utilisateur particulier
 * method GET
 * url /tasks
 */
$app->get('/tasks', 'authenticate', function() {
    global $user_id;
    $response = array();
    $db = new DbHandler();

    // aller chercher toutes les tâches de l'utilisateur
    $result = $db->getAllUserTasks($user_id);

    $response["error"] = false;
    $response["tasks"] = array();

    // boucle au travers du résultat et de la préparation du tableau des tâches
    while ($task = $result->fetch_assoc()) {
        $tmp = array();
        $tmp["id"] = $task["id"];
        $tmp["task"] = $task["task"];
        $tmp["status"] = $task["status"];
        $tmp["createdAt"] = $task["created_at"];
        array_push($response["tasks"], $tmp);
    }

    echoRespnse(200, $response);
});

/**
 *Lister une seule tâche d'un utilisateur particulier
 * method GET
 * url /tasks/:id
 *Retournera 404 si la tâche n'appartient pas à l'utilisateur
 */
$app->get('/tasks/:id', 'authenticate', function($task_id) {
    global $user_id;
    $response = array();
    $db = new DbHandler();

    //chercher tâche
    $result = $db->getTask($task_id, $user_id);

    if ($result != NULL) {
        $response["error"] = false;
        $response["id"] = $result["id"];
        $response["task"] = $result["task"];
        $response["status"] = $result["status"];
        $response["createdAt"] = $result["created_at"];
        echoRespnse(200, $response);
    } else {
        $response["error"] = true;
        $response["message"] = "La ressource demandée n'existe pas";
        echoRespnse(404, $response);
    }
});

/**
 * Mise à jour d'une tâche existante
 * method PUT
 * params task, status
 * url - /tasks/:id
 */
$app->put('/tasks/:id', 'authenticate', function($task_id) use($app) {
    // vérifier les paramètres requises
    verifyRequiredParams(array('task', 'status'));

    global $user_id;            
    $task = $app->request->put('task');
    $status = $app->request->put('status');

    $db = new DbHandler();
    $response = array();

    // Mise à jour de la tâche
    $result = $db->updateTask($user_id, $task_id, $task, $status);
    if ($result) {
        // Tache mise à jour
        $response["error"] = false;
        $response["message"] = "Tâche mise à jour avec succès";
    } else {
        // Le mise à jour de la tâche a échoué.
        $response["error"] = true;
        $response["message"] = "Le mise à jour de la tâche a échoué. S'il vous plaît essayer de nouveau!";
    }
    echoRespnse(200, $response);
});

/**
 * Suppression tâche. Les utilisateurs peuvent supprimer uniquement leurs tâches
 * method DELETE
 * url /tasks
 */
$app->delete('/tasks/:id', 'authenticate', function($task_id) use($app) {
    global $user_id;

    $db = new DbHandler();
    $response = array();
    $result = $db->deleteTask($user_id, $task_id);
    if ($result) {
        // tâche supprimé avec succès
        $response["error"] = false;
        $response["message"] = "tâche supprimé avec succès";
    } else {
        // "échec de la suppression d'une tâche.
        $response["error"] = true;
        $response["message"] = "échec de la suppression d'une tâche. S'il vous plaît essayer de nouveau!";
    }
    echoRespnse(200, $response);
});


$app->run();
?>