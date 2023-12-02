package services;

import java.util.List;
import java.util.Objects;

import dao.IDaoLocale;
import dao.IDaoRemote;
import entities.Ville;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityNotFoundException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Stateless(name = "kenza")
public class VilleService implements IDaoRemote<Ville>, IDaoLocale<Ville> {

	@PersistenceContext
	private EntityManager em;

	public EntityManager getEm() {
		return em;
	}

	public void setEm(EntityManager em) {
		this.em = em;
	}

	@Override
	public Ville create(Ville o) {
		em.persist(o);
		return o;
	}

	@Override
	public boolean delete(Ville o) {
		if (o != null) {
			// Check if the entity is managed before trying to remove it
			if (em.contains(o)) {
				em.remove(o);
			} else {
				// If the entity is detached, merge it first and then remove
				Ville managedEntity = em.merge(o);
				em.remove(managedEntity);
			}
			return true;
		}
		return false;
	}

	@Override
	public Ville update(Ville updatedVille) {
		Objects.requireNonNull(updatedVille.getId(), "Ville ID must not be null");

		Ville attachedVille = em.find(Ville.class, updatedVille.getId());

		if (attachedVille == null) {
			throw new EntityNotFoundException("Ville with ID " + updatedVille.getId() + " not found");
		}

		attachedVille.setNom(updatedVille.getNom());

		return em.merge(attachedVille);
	}

	@Override
	public Ville findById(int id) {
		// TODO Auto-generated method stub
		return em.find(Ville.class, id);
	}

	@Override
	public List<Ville> findAll() {
		Query query = em.createQuery("select v from Ville v");
		return query.getResultList();
	}

}
