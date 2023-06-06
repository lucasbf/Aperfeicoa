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

    protected abstract DbSet<T> Set { get; }

    protected virtual List<string> GetIncludeRelationship() 
    {
        return new List<string>();
    }

    public virtual void Create(T entity)
    {
        Set.Add(entity);
        _context.SaveChanges();
    }

    private IQueryable<T> GetQueryRelationsip()
    {
        IQueryable<T> query = Set;
        foreach (var item in GetIncludeRelationship())
        {
            query = query.Include(item);
        }
        return query;
    }

    public virtual T Get(Func<T, bool> predicate)
    {
        return GetQueryRelationsip().First(predicate);
    }

    public virtual IEnumerable<T> GetAll()
    {
        return GetQueryRelationsip().AsEnumerable();
    }

    public virtual void Remove(T entity)
    {
        Set.Remove(entity);
        _context.SaveChanges(); 
    }

    public virtual void Update(T entity)
    {
        Set.Update(entity);
        _context.SaveChanges();
    }
}