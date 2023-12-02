<%@page import="entities.Hotel"%>
<%@page import="entities.Ville"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Gestion des hotels</title>
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
            flex-wrap: wrap;
        }

        .ajouter-container {
            width: 100%;
            max-width: 400px;
            padding: 10px;
            box-sizing: border-box;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
            color: #777;
        }

        input[type="text"], select {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
            margin-bottom: 10px;
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
            display: block;
            margin-top: 10px;
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

        ul {
            list-style: none;
            padding: 0;
        }

        li {
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-bottom: 10px;
            padding: 10px;
            background-color: #fff;
        }

        span {
            display: block;
            margin-bottom: 5px;
        }

        .actions {
            display: flex;
            justify-content: space-between;
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
             .filter-section {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin: 10px auto;
        max-width: 300px; /* Adjust as needed */
        text-align: center;
    }

    .filter-section label,
    .filter-section select,
    .filter-section button {
        margin-bottom: 10px; /* Increased margin for better spacing */
    }

    .filter-section button {
        padding: 12px 20px; /* Adjust as needed for the button size */
        background-color: #3498db
; /* Sage color */
        color: #fff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        transition: background-color 0.3s ease;
    }

    .filter-section button:hover {
        background-color: #688665; /* Darker shade on hover */
    }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>

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
            window.location.href = 'HotelController?op=delete&id=' + id;
        } else {
            // If canceled
            Swal.fire('Cancelled', 'Your data is safe :)', 'info');
        }
    });
}

        function modifierHotel(id) {
            Swal.fire({
                title: 'Modifier un Hotel',
                html:
                    '<input id="nom" class="swal2-input" placeholder="Nom">' +
                    '<input id="adresse" class="swal2-input" placeholder="Adresse">' +
                    '<input id="telephone" class="swal2-input" placeholder="Telephone">' +
                    '<select id="villeId" class="swal2-select" style="width: 100%;">' +
                    '   <c:forEach items="${villes}" var="v">' +
                    '       <option value="${v.id}">${v.nom}</option>' +
                    '   </c:forEach>' +
                    '</select>',
                    showCancelButton: true,
                confirmButtonText: 'Modifier',
                preConfirm: () => {
                    const nom = Swal.getPopup().querySelector('#nom').value;
                    const adresse = Swal.getPopup().querySelector('#adresse').value;
                    const telephone = Swal.getPopup().querySelector('#telephone').value;
                    const villeId = Swal.getPopup().querySelector('#villeId').value;

                    if (!nom || !adresse || !telephone || !villeId) {
                        Swal.showValidationMessage('Veuillez remplir tous les champs.');
                    }

                    return { nom, adresse, telephone, villeId };
                }
            }).then((result) => {
                if (!result.dismiss) {
                    const { nom, adresse, telephone, villeId } = result.value;
                    // Construisez l'URL avec les données
                    const url = "HotelController?op=update&id=" + id +
                        "&nom=" + nom + "&adresse=" + adresse +
                        "&telephone=" + telephone  +
                        "&villeId=" + villeId;

                    // Redirigez l'utilisateur vers l'URL
                    window.location.href = url;
                }
            });
        }
        function filterByVille() {
            var selectedVilleId = document.getElementById("filterVille").value;
            window.location.href = "HotelController?filterVilleId=" + selectedVilleId;
        }
 </script>
</head>
<body>

    <form action="${pageContext.request.contextPath}/HotelController" method="get">
        <div class="ajouter-container">
            <label for="nom">Nom</label>
            <input id="nom" type="text" name="nom" />
            <label for="adresse">Adresse</label>
            <input id="adresse" type="text" name="adresse" />
            <label for="telephone">Téléphone</label>
            <input id="telephone" type="text" name="telephone" />
            <label for="villeId">Ville</label>
            <select id="villeId" name="villeId">
                <c:forEach var="v" items="${villes}">
                    <option value="${v.id}">${v.nom}</option>
                </c:forEach>
            </select>
           <input name="op" type="submit" value="Ajouter" class="form-submit" />
        </div>
    </form>
<div class="filter-section">
		<label for="filterVille">Filtrer par Ville :</label> <select
			id="filterVille" class="form-select">
			<option value="">Toutes les Villes</option>
			<c:forEach var="v" items="${villes}">
				<option value="${v.id}">${v.nom}</option>
			</c:forEach>
		</select>
		<button onclick="filterByVille()"
			>Filtrer</button>


	</div>
    <h1>Liste des hotels :</h1>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Adresse</th>
                <th>Téléphone</th>
                <th>Ville</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${hotels}" var="v">
                <tr>
                    <td>${v.id}</td>
                    <td>${v.nom}</td>
                    <td>${v.adresse}</td>
                    <td>${v.telephone}</td>
                    <td>${v.ville.nom}</td>
                    <td>
                        <a class="bndelete" href="#" onclick="confirmDelete(${v.id})">Supprimer</a>
                        <a class="bnupdate" href="javascript:void(0);" onclick="modifierHotel(${v.id})">Modifier</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>