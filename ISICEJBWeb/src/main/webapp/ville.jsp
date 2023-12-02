<%@page import="entities.Ville"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des villes</title>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 20px;
            background-color: #f3f3f3;
            color: #333;
        }

        h1 {
            color: #555;
            text-align: center;
            margin-bottom: 30px;
            text-transform: uppercase;
        }

        form {
            margin-bottom: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        input[type="text"] {
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
            margin-right: 10px;
            font-size: 14px;
            outline: none;
        }

        input[type="submit"] {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background-color: #888;
            color: #fff;
            cursor: pointer;
            font-size: 14px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
            text-transform: uppercase;
            font-size: 14px;
            color: #777;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f0f0f0;
        }

        .bndelete, .bnupdate {
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none; /* Remove underlines */
            display: inline-block;
        }

        .bndelete {
            background-color: #dd5555;
            color: #fff;
            margin-right: 10px;
        }

        .bnupdate {
            background-color: #55aa55;
            color: #fff;
        }

        .bndelete:hover, .bnupdate:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        // Function to show success notification
        function showSuccessNotification(message) {
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: message,
            });
        }

        // Function to show error notification
        function showErrorNotification(message) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: message,
            });
        }

        // Function for confirmation dialog
        function confirmDelete(id) {
            Swal.fire({
                title: 'Are you sure?',
                text: 'You will not be able to recover this data!',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, delete it!',
                cancelButtonText: 'No, keep it',
            }).then((result) => {
                if (result.isConfirmed) {
                    // If confirmed, you can call your delete function here
                    window.location.href = 'VilleController?op=delete&id=' + id;
                } else {
                    // If canceled
                    Swal.fire('Cancelled', 'Your data is safe :)', 'info');
                }
            });
        }

        // Function for updating Ville
        function modifierVille(id) {
            Swal.fire({
                title: 'Modifier le nom de cette ville',
                html: '<input id="nom" class="swal2-input" placeholder="Nom">',
                showCancelButton: true,
                confirmButtonText: 'Modifier',
                preConfirm: () => {
                    const nom = Swal.getPopup().querySelector('#nom').value;

                    if (!nom) {
                        Swal.showValidationMessage('Veuillez remplir tous les champs.');
                    }

                    return { nom };
                }
            }).then((result) => {
                if (!result.dismiss) {
                    const { nom } = result.value;
                    // Construct the URL with the data
                    const url = "VilleController?op=update&id=" + id + "&nom=" + nom;

                    // Redirect the user to the URL
                    window.location.href = url;
                }
            });
        }
    </script>
</head>
<body>

    <form action="VilleController" method="get">
        <table>
            <tr>
                <td>Ville</td>
                <td><input id="ville" type="text" name="ville" value="" required=""/></td>
                <td><input name="op" type="submit" value="Ajouter" /></td>
            </tr>
        </table>
    </form>
<h1>Liste des villes :</h1>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Ville</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${villes}" var="v">
                <tr>
                    <td>${v.id}</td>
                    <td>${v.nom}</td>
                    <td>
                        <a class="bndelete" href="#" onclick="confirmDelete(${v.id})">Supprimer</a>
                        <a class="bnupdate" href="javascript:void(0);" onclick="modifierVille(${v.id})">Modifier</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
