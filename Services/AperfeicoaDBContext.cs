using Aperfeicoa.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace Aperfeicoa.Services;

public abstract class AperfeicoaDBContext<T> where T : class
{
    protected readonly DbContext _context;

    public AperfeicoaDBContext(DbContext context)
    {
        _context = context;
    }

    public abstract DbSet<T> Set { get; }

    public void Create(T entity)
    {
        Set.Add(entity);
        _context.SaveChanges();
    }

    public T Get(T entity)
    {
        return Set.FirstOrDefault(entity);
    }

    public IEnumerable<T> GetAll()
    {
        return Set.AsEnumerable();
    }

    public void Remove(T entity)
    {
        Set.Remove(entity);
        _context.SaveChanges(); 
    }

    public void Update(T entity)
    {
        Set.Update(entity);
        _context.SaveChanges();
    }
}