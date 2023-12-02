package services;

import java.util.List;
import java.util.Objects;

import dao.IDaoHotel;
import dao.IDaoRemote;
import entities.Hotel;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityNotFoundException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Stateless(name = "nassima")
public class HotelService implements IDaoRemote<Hotel>, IDaoHotel {
	@PersistenceContext
	private EntityManager em1;

	@Override
	public Hotel create(Hotel o) {
		em1.persist(o);
		return o;
	}

	@Override
	public boolean delete(Hotel o) {
		if (o != null) {
			// Check if the entity is managed before trying to remove it
			if (em1.contains(o)) {
				em1.remove(o);
			} else {
				// If the entity is detached, merge it first and then remove
				Hotel managedEntity = em1.merge(o);
				em1.remove(managedEntity);
			}
			return true;
		}
		return false;
	}

	@Override
	public Hotel update(Hotel updatedHotel) {
	    Objects.requireNonNull(updatedHotel.getId(), "Hotel ID must not be null");

	    Hotel attachedHotel = em1.find(Hotel.class, updatedHotel.getId());

	    if (attachedHotel == null) {
	        throw new EntityNotFoundException("Hotel with ID " + updatedHotel.getId() + " not found");
	    }

	    // Update all relevant attributes
	    attachedHotel.setNom(updatedHotel.getNom());
	    attachedHotel.setAdresse(updatedHotel.getAdresse());
	    attachedHotel.setTelephone(updatedHotel.getTelephone());
	    attachedHotel.setVille(updatedHotel.getVille());
	    // Update other attributes as needed

	    return em1.merge(attachedHotel);
	}
	@Override
	public Hotel findById(int id) {
		return em1.find(Hotel.class, id);
	}

	@Override
	public List<Hotel> findAll() {
		Query query = em1.createQuery("select h from Hotel h");
		return query.getResultList();
	}

	@Override
	public List<Hotel> findHotelsByVille(int villeId) {
		Query query = em1.createQuery("select h from Hotel h where h.ville.id = :villeId");
		query.setParameter("villeId", villeId);
		return query.getResultList();
	}
}
